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
async function generateAnswer(context, question) {
    var _a;
    const systemPrompt = "You are a helpful assistant for a group ratings app. Users rate restaurants, movies, books and other items with their friend groups. " +
        "Answer questions about their ratings data based only on the provided context. Be concise and friendly. " +
        "If you reference specific items or groups, say their names clearly. " +
        "If the context doesn't contain enough information to answer, say so honestly.";
    const userMessage = `Context from ratings data:\n${context}\n\nQuestion: ${question}`;
    const response = await getClient().chat.completions.create({
        model: "gpt-4o",
        messages: [
            { role: "system", content: systemPrompt },
            { role: "user", content: userMessage },
        ],
        max_tokens: 500,
        temperature: 0.3,
    });
    return (_a = response.choices[0].message.content) !== null && _a !== void 0 ? _a : "I couldn't generate a response.";
}
//# sourceMappingURL=openai_client.js.map