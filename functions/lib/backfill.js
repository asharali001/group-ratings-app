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
exports.backfillPinecone = backfillPinecone;
const admin = __importStar(require("firebase-admin"));
const pinecone_client_1 = require("./pinecone_client");
async function backfillPinecone() {
    var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m;
    const db = admin.firestore();
    const errors = [];
    let groupsIndexed = 0;
    let itemsIndexed = 0;
    let ratingsIndexed = 0;
    // ── 1. Index all groups ──────────────────────────────────────────────────────
    const groupsSnap = await db.collection("groups").get();
    // Build a lookup map for use when indexing rating items
    const groupMap = {};
    for (const doc of groupsSnap.docs) {
        const g = doc.data();
        groupMap[doc.id] = {
            name: (_a = g.name) !== null && _a !== void 0 ? _a : "",
            category: (_b = g.category) !== null && _b !== void 0 ? _b : "",
            memberIds: (_c = g.memberIds) !== null && _c !== void 0 ? _c : [],
        };
        const memberNames = ((_d = g.members) !== null && _d !== void 0 ? _d : []).map((m) => m.name);
        const text = `Group: ${g.name}. Category: ${(_e = g.category) !== null && _e !== void 0 ? _e : ""}. ` +
            `Description: ${(_f = g.description) !== null && _f !== void 0 ? _f : ""}. Members: ${memberNames.join(", ")}.`;
        const metadata = {
            type: "group",
            groupId: doc.id,
            memberIds: (_g = g.memberIds) !== null && _g !== void 0 ? _g : [],
            groupName: g.name,
            groupCategory: g.category,
        };
        try {
            await (0, pinecone_client_1.upsertVector)(`group_${doc.id}`, text, metadata);
            groupsIndexed++;
        }
        catch (e) {
            errors.push(`group_${doc.id}: ${e}`);
        }
    }
    // ── 2. Index all rating items + user ratings ─────────────────────────────────
    const itemsSnap = await db.collection("rating_items").get();
    for (const doc of itemsSnap.docs) {
        const item = doc.data();
        const group = (_h = groupMap[item.groupId]) !== null && _h !== void 0 ? _h : {
            name: "",
            category: "",
            memberIds: [],
        };
        const ratings = (_j = item.ratings) !== null && _j !== void 0 ? _j : [];
        const avg = ratings.length > 0
            ? (ratings.reduce((sum, r) => sum + r.ratingValue, 0) / ratings.length).toFixed(1)
            : "not yet rated";
        // Item vector
        const itemText = `Item: ${item.name} in ${group.name}. Location: ${(_k = item.location) !== null && _k !== void 0 ? _k : ""}. ` +
            `Description: ${(_l = item.description) !== null && _l !== void 0 ? _l : ""}. Category: ${group.category}. ` +
            `Average rating: ${avg}.`;
        const itemMetadata = {
            type: "item",
            groupId: item.groupId,
            memberIds: group.memberIds,
            itemId: doc.id,
            itemName: item.name,
            groupName: group.name,
            groupCategory: group.category,
        };
        try {
            await (0, pinecone_client_1.upsertVector)(`item_${doc.id}`, itemText, itemMetadata);
            itemsIndexed++;
        }
        catch (e) {
            errors.push(`item_${doc.id}: ${e}`);
        }
        // User rating vectors
        const userRatings = (_m = item.ratings) !== null && _m !== void 0 ? _m : [];
        for (const r of userRatings) {
            const ratingText = `${r.userName} rated ${item.name} in ${group.name}: ` +
                `${r.ratingValue}/${item.ratingScale}. ` +
                (r.comment ? `Review: ${r.comment}` : "No comment.");
            const ratingMeta = {
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
                await (0, pinecone_client_1.upsertVector)(`rating_${doc.id}_${r.userId}`, ratingText, ratingMeta);
                ratingsIndexed++;
            }
            catch (e) {
                errors.push(`rating_${doc.id}_${r.userId}: ${e}`);
            }
        }
    }
    return { groupsIndexed, itemsIndexed, ratingsIndexed, errors };
}
//# sourceMappingURL=backfill.js.map