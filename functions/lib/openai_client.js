"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.embedText = embedText;
exports.generateAnswer = generateAnswer;
const openai_1 = __importDefault(require("openai"));
let _client = null;
function getClient() {
    if (!_client) {
        const apiKey = process.env.OPENAI_API_KEY;
        if (!apiKey)
            throw new Error("OPENAI_API_KEY environment variable not set");
        _client = new openai_1.default({ apiKey });
    }
    return _client;
}
async function embedText(text) {
    const response = await getClient().embeddings.create({
        model: "text-embedding-3-small",
        input: text,
    });
    return response.data[0].embedding;
}
async function generateAnswer(context, question, contextIds) {
    var _a, _b, _c;
    const systemPrompt = "You are Kretik, a friendly assistant built into the Kretik group ratings app. " +
        "Users rate restaurants, movies, books and other items with their friend groups. " +
        "Answer questions about ratings data based only on the provided context. " +
        "For casual messages (greetings, small talk), respond naturally without referencing ratings data.\n\n" +
        "You MUST respond with valid JSON in this exact shape:\n" +
        '{ "answer": "<your response>", "usedIds": ["<id1>", "<id2>"] }\n\n' +
        "STRICT RULES for usedIds:\n" +
        "- Only include an ID if that specific item/group DIRECTLY appears in your answer as evidence for the user's question.\n" +
        "- If your answer says you cannot find the requested information, usedIds MUST be [].\n" +
        "- If the question is casual/unrelated to ratings, usedIds MUST be [].\n" +
        "- Do NOT include IDs just because they appeared in the context. Only include IDs you are actively surfacing to the user as relevant results.";
    const idList = contextIds.length > 0
        ? `\n\nAvailable context IDs (use these in usedIds if cited):\n${contextIds.join("\n")}`
        : "";
    const userMessage = `Context from ratings data:\n${context}${idList}\n\nQuestion: ${question}`;
    const response = await getClient().chat.completions.create({
        model: "gpt-4.1-nano",
        messages: [
            { role: "system", content: systemPrompt },
            { role: "user", content: userMessage },
        ],
        max_tokens: 600,
        temperature: 0.3,
        response_format: { type: "json_object" },
    });
    try {
        const parsed = JSON.parse((_a = response.choices[0].message.content) !== null && _a !== void 0 ? _a : "{}");
        return {
            answer: (_b = parsed.answer) !== null && _b !== void 0 ? _b : "I couldn't generate a response.",
            usedIds: Array.isArray(parsed.usedIds) ? parsed.usedIds : [],
        };
    }
    catch (_d) {
        return {
            answer: (_c = response.choices[0].message.content) !== null && _c !== void 0 ? _c : "I couldn't generate a response.",
            usedIds: [],
        };
    }
}
//# sourceMappingURL=openai_client.js.map