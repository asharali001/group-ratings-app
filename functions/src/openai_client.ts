import OpenAI from "openai";

let _client: OpenAI | null = null;

function getClient(): OpenAI {
  if (!_client) {
    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) throw new Error("OPENAI_API_KEY environment variable not set");
    _client = new OpenAI({ apiKey });
  }
  return _client;
}

export async function embedText(text: string): Promise<number[]> {
  const response = await getClient().embeddings.create({
    model: "text-embedding-3-small",
    input: text,
  });
  return response.data[0].embedding;
}

export async function generateAnswer(
  context: string,
  question: string,
  contextIds: string[]
): Promise<{ answer: string; usedIds: string[] }> {
  const systemPrompt =
    "You are Kretik, a friendly assistant built into the Kretik group ratings app. " +
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

  const userMessage =
    `Context from ratings data:\n${context}${idList}\n\nQuestion: ${question}`;

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
    const parsed = JSON.parse(
      response.choices[0].message.content ?? "{}"
    ) as { answer?: string; usedIds?: string[] };
    return {
      answer: parsed.answer ?? "I couldn't generate a response.",
      usedIds: Array.isArray(parsed.usedIds) ? parsed.usedIds : [],
    };
  } catch {
    return {
      answer: response.choices[0].message.content ?? "I couldn't generate a response.",
      usedIds: [],
    };
  }
}
