// One-time backfill script — run with: node backfill_script.mjs
// Requires: OPENAI_API_KEY and PINECONE_API_KEY set in your environment
// Uses Application Default Credentials (firebase login already sets these)

import { initializeApp, cert, getApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { Pinecone } from "@pinecone-database/pinecone";
import OpenAI from "openai";

// ── Config ────────────────────────────────────────────────────────────────────

const FIREBASE_PROJECT_ID = "v-group-ratings";
const PINECONE_INDEX = "group-ratings";

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const pinecone = new Pinecone({ apiKey: process.env.PINECONE_API_KEY });

initializeApp({ projectId: FIREBASE_PROJECT_ID });
const db = getFirestore();
const index = pinecone.index(PINECONE_INDEX);

// ── Helpers ───────────────────────────────────────────────────────────────────

async function embed(text) {
  const res = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: text,
  });
  return res.data[0].embedding;
}

async function upsert(id, text, metadata) {
  const values = await embed(text);
  await index.upsert([{ id, values, metadata: { ...metadata, textContent: text } }]);
}

// ── Backfill ──────────────────────────────────────────────────────────────────

let groupsIndexed = 0, itemsIndexed = 0, ratingsIndexed = 0;
const errors = [];
const groupMap = {};

console.log("Fetching groups...");
const groupsSnap = await db.collection("groups").get();

for (const doc of groupsSnap.docs) {
  const g = doc.data();
  groupMap[doc.id] = {
    name: g.name ?? "",
    category: g.category ?? "",
    memberIds: g.memberIds ?? [],
  };

  const memberNames = (g.members ?? []).map((m) => m.name);
  const text = `Group: ${g.name}. Category: ${g.category ?? ""}. Description: ${g.description ?? ""}. Members: ${memberNames.join(", ")}.`;

  try {
    await upsert(`group_${doc.id}`, text, {
      type: "group",
      groupId: doc.id,
      memberIds: g.memberIds ?? [],
      groupName: g.name,
      groupCategory: g.category ?? "",
    });
    groupsIndexed++;
    console.log(`  ✓ group: ${g.name}`);
  } catch (e) {
    errors.push(`group_${doc.id}: ${e.message}`);
    console.error(`  ✗ group_${doc.id}: ${e.message}`);
  }
}

console.log(`\nFetching rating items...`);
const itemsSnap = await db.collection("rating_items").get();

for (const doc of itemsSnap.docs) {
  const item = doc.data();
  const group = groupMap[item.groupId] ?? { name: "", category: "", memberIds: [] };

  const ratings = item.ratings ?? [];
  const avg = ratings.length > 0
    ? (ratings.reduce((s, r) => s + r.ratingValue, 0) / ratings.length).toFixed(1)
    : "not yet rated";

  const itemText = `Item: ${item.name} in ${group.name}. Location: ${item.location ?? ""}. Description: ${item.description ?? ""}. Category: ${group.category}. Average rating: ${avg}.`;

  try {
    await upsert(`item_${doc.id}`, itemText, {
      type: "item",
      groupId: item.groupId,
      memberIds: group.memberIds,
      itemId: doc.id,
      itemName: item.name,
      groupName: group.name,
      groupCategory: group.category,
    });
    itemsIndexed++;
    console.log(`  ✓ item: ${item.name}`);
  } catch (e) {
    errors.push(`item_${doc.id}: ${e.message}`);
    console.error(`  ✗ item_${doc.id}: ${e.message}`);
  }

  for (const r of ratings) {
    const ratingText = `${r.userName} rated ${item.name} in ${group.name}: ${r.ratingValue}/${item.ratingScale}. ${r.comment ? `Review: ${r.comment}` : "No comment."}`;

    try {
      await upsert(`rating_${doc.id}_${r.userId}`, ratingText, {
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
      });
      ratingsIndexed++;
      console.log(`    ✓ rating: ${r.userName} → ${item.name}`);
    } catch (e) {
      errors.push(`rating_${doc.id}_${r.userId}: ${e.message}`);
      console.error(`    ✗ rating_${doc.id}_${r.userId}: ${e.message}`);
    }
  }
}

console.log(`\n── Done ──────────────────────────────────────`);
console.log(`Groups indexed:  ${groupsIndexed}`);
console.log(`Items indexed:   ${itemsIndexed}`);
console.log(`Ratings indexed: ${ratingsIndexed}`);
if (errors.length) console.log(`Errors:`, errors);
