"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.upsertVector = upsertVector;
exports.queryVectors = queryVectors;
exports.deleteVector = deleteVector;
exports.deleteVectorsByPrefix = deleteVectorsByPrefix;
const pinecone_1 = require("@pinecone-database/pinecone");
const openai_client_1 = require("./openai_client");
const INDEX_NAME = "group-ratings";
let _pinecone = null;
function getClient() {
    if (!_pinecone) {
        const apiKey = process.env.PINECONE_API_KEY;
        if (!apiKey)
            throw new Error("PINECONE_API_KEY environment variable not set");
        _pinecone = new pinecone_1.Pinecone({ apiKey });
    }
    return _pinecone;
}
function getIndex() {
    return getClient().index(INDEX_NAME);
}
async function upsertVector(id, text, metadata) {
    const values = await (0, openai_client_1.embedText)(text);
    await getIndex().upsert([
        {
            id,
            values,
            metadata: Object.assign(Object.assign({}, metadata), { textContent: text }),
        },
    ]);
}
async function queryVectors(userId, questionEmbedding, topK = 10) {
    var _a;
    const results = await getIndex().query({
        vector: questionEmbedding,
        topK,
        includeMetadata: true,
        filter: { memberIds: { $in: [userId] } },
    });
    return ((_a = results.matches) !== null && _a !== void 0 ? _a : []).map((match) => {
        var _a;
        return ({
            id: match.id,
            score: (_a = match.score) !== null && _a !== void 0 ? _a : 0,
            metadata: match.metadata,
        });
    });
}
async function deleteVector(id) {
    await getIndex().deleteOne(id);
}
async function deleteVectorsByPrefix(prefix) {
    var _a;
    // Pinecone doesn't support prefix deletion directly; we list and delete
    // For serverless indexes, use deleteAll with filter isn't supported either.
    // We'll use namespace-less deletion by fetching IDs first via a dummy query.
    // This is a best-effort approach — in production use a namespace per groupId.
    try {
        const results = await getIndex().query({
            vector: new Array(1536).fill(0),
            topK: 100,
            includeMetadata: false,
            filter: { itemId: { $eq: prefix.replace("rating_", "").split("_")[0] } },
        });
        const ids = ((_a = results.matches) !== null && _a !== void 0 ? _a : []).map((m) => m.id);
        if (ids.length > 0) {
            await getIndex().deleteMany(ids);
        }
    }
    catch (_b) {
        // Non-critical — vectors will become stale but won't affect correctness
    }
}
//# sourceMappingURL=pinecone_client.js.map