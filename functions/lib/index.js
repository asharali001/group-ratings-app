"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.runBackfill = exports.onRatingItemWrite = exports.onGroupWrite = exports.queryAI = void 0;
const admin = __importStar(require("firebase-admin"));
const params_1 = require("firebase-functions/params");
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-functions/v2/firestore");
const backfill_1 = require("./backfill");
const openAIKey = (0, params_1.defineSecret)("OPENAI_API_KEY");
const pineconeKey = (0, params_1.defineSecret)("PINECONE_API_KEY");
const openai_client_1 = require("./openai_client");
const pinecone_client_1 = require("./pinecone_client");
admin.initializeApp();
// ─── HTTPS Callable: queryAI ─────────────────────────────────────────────────
exports.queryAI = (0, https_1.onCall)({ secrets: [openAIKey, pineconeKey] }, async (request) => {
    var _a, _b, _c, _d, _e;
    process.env.OPENAI_API_KEY = openAIKey.value();
    process.env.PINECONE_API_KEY = pineconeKey.value();
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Must be authenticated.");
    }
    const question = request.data.question;
    if (!question || typeof question !== "string" || question.trim().length === 0) {
        throw new https_1.HttpsError("invalid-argument", "question is required.");
    }
    // Support mirror mode: use provided userId if the caller is an allowed admin
    let userId = request.auth.uid;
    const mirrorUserId = request.data.mirrorUserId;
    if (mirrorUserId && typeof mirrorUserId === "string") {
        const configDoc = await admin.firestore().collection("app_config").doc("mirror_access").get();
        const allowedEmails = configDoc.exists ? ((_b = (_a = configDoc.data()) === null || _a === void 0 ? void 0 : _a.allowedEmails) !== null && _b !== void 0 ? _b : []) : [];
        const callerEmail = (_c = request.auth.token.email) !== null && _c !== void 0 ? _c : "";
        if (allowedEmails.includes(callerEmail)) {
            userId = mirrorUserId;
        }
    }
    // 1. Embed the question
    const questionEmbedding = await (0, openai_client_1.embedText)(question.trim());
    // 2. Query Pinecone (filtered to user's groups)
    const results = await (0, pinecone_client_1.queryVectors)(userId, questionEmbedding, 10);
    // Only include context from results that are at least loosely related (≥0.5)
    const CONTEXT_THRESHOLD = 0.5;
    const relevantResults = results.filter((r) => r.score >= CONTEXT_THRESHOLD);
    if (relevantResults.length === 0) {
        return {
            answer: "I don't have enough data to answer that yet. Try rating some items in your groups first!",
            references: [],
        };
    }
    // 3. Build context string and ID list (from loosely relevant results)
    const contextLines = relevantResults
        .map((r) => { var _a; return (_a = r.metadata.textContent) !== null && _a !== void 0 ? _a : ""; })
        .filter(Boolean);
    const context = contextLines.join("\n");
    // Build a map of Pinecone vector ID → result for reference lookup
    const resultById = new Map(relevantResults.map((r) => [r.id, r]));
    const contextIds = relevantResults.map((r) => r.id);
    // 4. Generate answer — GPT tells us which IDs it actually cited
    const { answer, usedIds } = await (0, openai_client_1.generateAnswer)(context, question.trim(), contextIds);
    // 5. Build references only from IDs GPT explicitly cited
    const seenRefIds = new Set();
    const references = [];
    for (const vectorId of usedIds) {
        const r = resultById.get(vectorId);
        if (!r)
            continue;
        const meta = r.metadata;
        if (meta.type === "group" && meta.groupId && !seenRefIds.has(meta.groupId)) {
            seenRefIds.add(meta.groupId);
            references.push({
                type: "group",
                id: meta.groupId,
                name: (_d = meta.groupName) !== null && _d !== void 0 ? _d : "Group",
            });
        }
        if ((meta.type === "item" || meta.type === "user_rating") &&
            meta.itemId &&
            !seenRefIds.has(meta.itemId)) {
            seenRefIds.add(meta.itemId);
            references.push({
                type: "ratingItem",
                id: meta.itemId,
                name: (_e = meta.itemName) !== null && _e !== void 0 ? _e : "Item",
                groupId: meta.groupId,
            });
        }
    }
    return { answer, references };
});
// ─── Firestore Trigger: groups/{groupId} ─────────────────────────────────────
exports.onGroupWrite = (0, firestore_1.onDocumentWritten)({ document: "groups/{groupId}", secrets: [openAIKey, pineconeKey] }, async (event) => {
    var _a, _b, _c, _d;
    process.env.OPENAI_API_KEY = openAIKey.value();
    process.env.PINECONE_API_KEY = pineconeKey.value();
    const groupId = event.params.groupId;
    const change = event.data;
    if (!change)
        return;
    if (!change.after.exists) {
        await (0, pinecone_client_1.deleteVector)(`group_${groupId}`);
        return;
    }
    const group = change.after.data();
    const memberNames = ((_a = group.members) !== null && _a !== void 0 ? _a : []).map((m) => m.name);
    const text = `Group: ${group.name}. Category: ${(_b = group.category) !== null && _b !== void 0 ? _b : ""}. ` +
        `Description: ${(_c = group.description) !== null && _c !== void 0 ? _c : ""}. Members: ${memberNames.join(", ")}.`;
    const metadata = {
        type: "group",
        groupId,
        memberIds: (_d = group.memberIds) !== null && _d !== void 0 ? _d : [],
        groupName: group.name,
        groupCategory: group.category,
    };
    await (0, pinecone_client_1.upsertVector)(`group_${groupId}`, text, metadata);
});
// ─── Firestore Trigger: rating_items/{itemId} ─────────────────────────────────
exports.onRatingItemWrite = (0, firestore_1.onDocumentWritten)({ document: "rating_items/{itemId}", secrets: [openAIKey, pineconeKey] }, async (event) => {
    var _a, _b, _c, _d, _e, _f, _g;
    process.env.OPENAI_API_KEY = openAIKey.value();
    process.env.PINECONE_API_KEY = pineconeKey.value();
    const itemId = event.params.itemId;
    const change = event.data;
    if (!change)
        return;
    if (!change.after.exists) {
        await (0, pinecone_client_1.deleteVector)(`item_${itemId}`);
        await (0, pinecone_client_1.deleteVectorsByPrefix)(`rating_${itemId}`);
        return;
    }
    const item = change.after.data();
    // Fetch parent group for context
    let groupName = "";
    let groupCategory = "";
    let memberIds = [];
    try {
        const groupDoc = await admin
            .firestore()
            .collection("groups")
            .doc(item.groupId)
            .get();
        if (groupDoc.exists) {
            const g = groupDoc.data();
            groupName = (_a = g.name) !== null && _a !== void 0 ? _a : "";
            groupCategory = (_b = g.category) !== null && _b !== void 0 ? _b : "";
            memberIds = (_c = g.memberIds) !== null && _c !== void 0 ? _c : [];
        }
    }
    catch (_h) {
        // Continue without group context
    }
    // Compute average
    const ratings = (_d = item.ratings) !== null && _d !== void 0 ? _d : [];
    const avg = ratings.length > 0
        ? (ratings.reduce((sum, r) => sum + r.ratingValue, 0) / ratings.length).toFixed(1)
        : "not yet rated";
    // Upsert item vector
    const itemText = `Item: ${item.name} in ${groupName}. Location: ${(_e = item.location) !== null && _e !== void 0 ? _e : ""}. ` +
        `Description: ${(_f = item.description) !== null && _f !== void 0 ? _f : ""}. Category: ${groupCategory}. ` +
        `Average rating: ${avg}.`;
    const itemMetadata = {
        type: "item",
        groupId: item.groupId,
        memberIds,
        itemId,
        itemName: item.name,
        groupName,
        groupCategory,
    };
    await (0, pinecone_client_1.upsertVector)(`item_${itemId}`, itemText, itemMetadata);
    // Upsert one vector per user rating
    const userRatings = (_g = item.ratings) !== null && _g !== void 0 ? _g : [];
    const upsertPromises = userRatings.map((r) => {
        const ratingText = `${r.userName} rated ${item.name} in ${groupName}: ` +
            `${r.ratingValue}/${item.ratingScale}. ` +
            (r.comment ? `Review: ${r.comment}` : "No comment.");
        const ratingMeta = {
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
        return (0, pinecone_client_1.upsertVector)(`rating_${itemId}_${r.userId}`, ratingText, ratingMeta);
    });
    await Promise.all(upsertPromises);
});
// ─── One-time Backfill ────────────────────────────────────────────────────────
exports.runBackfill = (0, https_1.onCall)({ secrets: [openAIKey, pineconeKey], timeoutSeconds: 540 }, async (request) => {
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Must be authenticated.");
    }
    process.env.OPENAI_API_KEY = openAIKey.value();
    process.env.PINECONE_API_KEY = pineconeKey.value();
    return (0, backfill_1.backfillPinecone)();
});
//# sourceMappingURL=index.js.map