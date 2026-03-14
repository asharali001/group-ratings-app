import * as admin from "firebase-admin";
import { defineSecret } from "firebase-functions/params";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { backfillPinecone } from "./backfill";

const openAIKey = defineSecret("OPENAI_API_KEY");
const pineconeKey = defineSecret("PINECONE_API_KEY");
import { embedText, generateAnswer } from "./openai_client";
import {
  upsertVector,
  queryVectors,
  deleteVector,
  deleteVectorsByPrefix,
} from "./pinecone_client";
import { AIReference, PineconeMetadata } from "./types";

admin.initializeApp();

// ─── HTTPS Callable: queryAI ─────────────────────────────────────────────────

export const queryAI = onCall(
  { secrets: [openAIKey, pineconeKey] },
  async (request) => {
  process.env.OPENAI_API_KEY = openAIKey.value();
  process.env.PINECONE_API_KEY = pineconeKey.value();

  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated.");
  }

  const question: string = request.data.question;
  if (!question || typeof question !== "string" || question.trim().length === 0) {
    throw new HttpsError("invalid-argument", "question is required.");
  }

  // Support mirror mode: use provided userId if the caller is an allowed admin
  let userId = request.auth.uid;
  const mirrorUserId: string | undefined = request.data.mirrorUserId;
  if (mirrorUserId && typeof mirrorUserId === "string") {
    const configDoc = await admin.firestore().collection("app_config").doc("mirror_access").get();
    const allowedEmails: string[] = configDoc.exists ? (configDoc.data()?.allowedEmails ?? []) : [];
    const callerEmail = request.auth.token.email ?? "";
    if (allowedEmails.includes(callerEmail)) {
      userId = mirrorUserId;
    }
  }

  // 1. Embed the question
  const questionEmbedding = await embedText(question.trim());

  // 2. Query Pinecone (filtered to user's groups)
  const results = await queryVectors(userId, questionEmbedding, 10);

  // Only include context from results that are at least loosely related (≥0.5)
  const CONTEXT_THRESHOLD = 0.5;

  const relevantResults = results.filter((r) => r.score >= CONTEXT_THRESHOLD);

  if (relevantResults.length === 0) {
    return {
      answer:
        "I don't have enough data to answer that yet. Try rating some items in your groups first!",
      references: [],
    };
  }

  // 3. Build context string and ID list (from loosely relevant results)
  const contextLines = relevantResults
    .map((r) => r.metadata.textContent ?? "")
    .filter(Boolean);
  const context = contextLines.join("\n");

  // Build a map of Pinecone vector ID → result for reference lookup
  const resultById = new Map(relevantResults.map((r) => [r.id, r]));
  const contextIds = relevantResults.map((r) => r.id);

  // 4. Generate answer — GPT tells us which IDs it actually cited
  const { answer, usedIds } = await generateAnswer(context, question.trim(), contextIds);

  // 5. Build references only from IDs GPT explicitly cited
  const seenRefIds = new Set<string>();
  const references: AIReference[] = [];

  for (const vectorId of usedIds) {
    const r = resultById.get(vectorId);
    if (!r) continue;
    const meta = r.metadata;

    if (meta.type === "group" && meta.groupId && !seenRefIds.has(meta.groupId)) {
      seenRefIds.add(meta.groupId);
      references.push({
        type: "group",
        id: meta.groupId,
        name: meta.groupName ?? "Group",
      });
    }

    if (
      (meta.type === "item" || meta.type === "user_rating") &&
      meta.itemId &&
      !seenRefIds.has(meta.itemId)
    ) {
      seenRefIds.add(meta.itemId);
      references.push({
        type: "ratingItem",
        id: meta.itemId,
        name: meta.itemName ?? "Item",
        groupId: meta.groupId,
      });
    }
  }

  return { answer, references };
});

// ─── Firestore Trigger: groups/{groupId} ─────────────────────────────────────

export const onGroupWrite = onDocumentWritten(
  { document: "groups/{groupId}", secrets: [openAIKey, pineconeKey] },
  async (event) => {
  process.env.OPENAI_API_KEY = openAIKey.value();
  process.env.PINECONE_API_KEY = pineconeKey.value();
    const groupId = event.params.groupId;
    const change = event.data;
    if (!change) return;

    if (!change.after.exists) {
      await deleteVector(`group_${groupId}`);
      return;
    }

    const group = change.after.data()!;
    const memberNames: string[] = (group.members ?? []).map(
      (m: { name: string }) => m.name
    );
    const text =
      `Group: ${group.name}. Category: ${group.category ?? ""}. ` +
      `Description: ${group.description ?? ""}. Members: ${memberNames.join(", ")}.`;

    const metadata: PineconeMetadata = {
      type: "group",
      groupId,
      memberIds: group.memberIds ?? [],
      groupName: group.name,
      groupCategory: group.category,
    };

    await upsertVector(`group_${groupId}`, text, metadata);
  }
);

// ─── Firestore Trigger: rating_items/{itemId} ─────────────────────────────────

export const onRatingItemWrite = onDocumentWritten(
  { document: "rating_items/{itemId}", secrets: [openAIKey, pineconeKey] },
  async (event) => {
  process.env.OPENAI_API_KEY = openAIKey.value();
  process.env.PINECONE_API_KEY = pineconeKey.value();
    const itemId = event.params.itemId;
    const change = event.data;
    if (!change) return;

    if (!change.after.exists) {
      await deleteVector(`item_${itemId}`);
      await deleteVectorsByPrefix(`rating_${itemId}`);
      return;
    }

    const item = change.after.data()!;

    // Fetch parent group for context
    let groupName = "";
    let groupCategory = "";
    let memberIds: string[] = [];
    try {
      const groupDoc = await admin
        .firestore()
        .collection("groups")
        .doc(item.groupId)
        .get();
      if (groupDoc.exists) {
        const g = groupDoc.data()!;
        groupName = g.name ?? "";
        groupCategory = g.category ?? "";
        memberIds = g.memberIds ?? [];
      }
    } catch {
      // Continue without group context
    }

    // Compute average
    const ratings: Array<{ ratingValue: number; ratingScale: number }> =
      item.ratings ?? [];
    const avg =
      ratings.length > 0
        ? (
            ratings.reduce((sum, r) => sum + r.ratingValue, 0) / ratings.length
          ).toFixed(1)
        : "not yet rated";

    // Upsert item vector
    const itemText =
      `Item: ${item.name} in ${groupName}. Location: ${item.location ?? ""}. ` +
      `Description: ${item.description ?? ""}. Category: ${groupCategory}. ` +
      `Average rating: ${avg}.`;

    const itemMetadata: PineconeMetadata = {
      type: "item",
      groupId: item.groupId,
      memberIds,
      itemId,
      itemName: item.name,
      groupName,
      groupCategory,
    };

    await upsertVector(`item_${itemId}`, itemText, itemMetadata);

    // Upsert one vector per user rating
    const userRatings: Array<{
      userId: string;
      userName: string;
      ratingValue: number;
      comment?: string;
    }> = item.ratings ?? [];

    const upsertPromises = userRatings.map((r) => {
      const ratingText =
        `${r.userName} rated ${item.name} in ${groupName}: ` +
        `${r.ratingValue}/${item.ratingScale}. ` +
        (r.comment ? `Review: ${r.comment}` : "No comment.");

      const ratingMeta: PineconeMetadata = {
        type: "user_rating",
        groupId: item.groupId,
        memberIds,
        itemId,
        itemName: item.name,
        userId: r.userId,
        userName: r.userName,
        ratingValue: r.ratingValue,
        ratingScale: item.ratingScale,
        groupName,
        groupCategory,
      };

      return upsertVector(`rating_${itemId}_${r.userId}`, ratingText, ratingMeta);
    });

    await Promise.all(upsertPromises);
  }
);

// ─── One-time Backfill ────────────────────────────────────────────────────────

export const runBackfill = onCall(
  { secrets: [openAIKey, pineconeKey], timeoutSeconds: 540 },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be authenticated.");
    }
    process.env.OPENAI_API_KEY = openAIKey.value();
    process.env.PINECONE_API_KEY = pineconeKey.value();
    return backfillPinecone();
  }
);
