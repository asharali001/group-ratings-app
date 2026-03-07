import * as admin from "firebase-admin";
import { upsertVector } from "./pinecone_client";
import { PineconeMetadata } from "./types";

export async function backfillPinecone(): Promise<{
  groupsIndexed: number;
  itemsIndexed: number;
  ratingsIndexed: number;
  errors: string[];
}> {
  const db = admin.firestore();
  const errors: string[] = [];
  let groupsIndexed = 0;
  let itemsIndexed = 0;
  let ratingsIndexed = 0;

  // ── 1. Index all groups ──────────────────────────────────────────────────────

  const groupsSnap = await db.collection("groups").get();

  // Build a lookup map for use when indexing rating items
  const groupMap: Record<
    string,
    { name: string; category: string; memberIds: string[] }
  > = {};

  for (const doc of groupsSnap.docs) {
    const g = doc.data();
    groupMap[doc.id] = {
      name: g.name ?? "",
      category: g.category ?? "",
      memberIds: g.memberIds ?? [],
    };

    const memberNames: string[] = (g.members ?? []).map(
      (m: { name: string }) => m.name
    );
    const text =
      `Group: ${g.name}. Category: ${g.category ?? ""}. ` +
      `Description: ${g.description ?? ""}. Members: ${memberNames.join(", ")}.`;

    const metadata: PineconeMetadata = {
      type: "group",
      groupId: doc.id,
      memberIds: g.memberIds ?? [],
      groupName: g.name,
      groupCategory: g.category,
    };

    try {
      await upsertVector(`group_${doc.id}`, text, metadata);
      groupsIndexed++;
    } catch (e) {
      errors.push(`group_${doc.id}: ${e}`);
    }
  }

  // ── 2. Index all rating items + user ratings ─────────────────────────────────

  const itemsSnap = await db.collection("rating_items").get();

  for (const doc of itemsSnap.docs) {
    const item = doc.data();
    const group = groupMap[item.groupId] ?? {
      name: "",
      category: "",
      memberIds: [],
    };

    const ratings: Array<{ ratingValue: number }> = item.ratings ?? [];
    const avg =
      ratings.length > 0
        ? (
            ratings.reduce((sum, r) => sum + r.ratingValue, 0) / ratings.length
          ).toFixed(1)
        : "not yet rated";

    // Item vector
    const itemText =
      `Item: ${item.name} in ${group.name}. Location: ${item.location ?? ""}. ` +
      `Description: ${item.description ?? ""}. Category: ${group.category}. ` +
      `Average rating: ${avg}.`;

    const itemMetadata: PineconeMetadata = {
      type: "item",
      groupId: item.groupId,
      memberIds: group.memberIds,
      itemId: doc.id,
      itemName: item.name,
      groupName: group.name,
      groupCategory: group.category,
    };

    try {
      await upsertVector(`item_${doc.id}`, itemText, itemMetadata);
      itemsIndexed++;
    } catch (e) {
      errors.push(`item_${doc.id}: ${e}`);
    }

    // User rating vectors
    const userRatings: Array<{
      userId: string;
      userName: string;
      ratingValue: number;
      comment?: string;
    }> = item.ratings ?? [];

    for (const r of userRatings) {
      const ratingText =
        `${r.userName} rated ${item.name} in ${group.name}: ` +
        `${r.ratingValue}/${item.ratingScale}. ` +
        (r.comment ? `Review: ${r.comment}` : "No comment.");

      const ratingMeta: PineconeMetadata = {
        type: "user_rating",
        groupId: item.groupId,
        memberIds: group.memberIds,
        itemId: doc.id,
        itemName: item.name,
        userId: r.userId,
        userName: r.userName,
        ratingValue: r.ratingValue,
        ratingScale: item.ratingScale,
        groupName: group.name,
        groupCategory: group.category,
      };

      try {
        await upsertVector(`rating_${doc.id}_${r.userId}`, ratingText, ratingMeta);
        ratingsIndexed++;
      } catch (e) {
        errors.push(`rating_${doc.id}_${r.userId}: ${e}`);
      }
    }
  }

  return { groupsIndexed, itemsIndexed, ratingsIndexed, errors };
}
