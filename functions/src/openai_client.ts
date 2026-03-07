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
  question: string
): Promise<string> {
  const systemPrompt =
    "You are a helpful assistant for a group ratings app. Users rate restaurants, movies, books and other items with their friend groups. " +
    "Answer questions about their ratings data based only on the provided context. Be concise and friendly. " +
    "If you reference specific items or groups, say their names clearly. " +
    "If the context doesn't contain enough information to answer, say so honestly.";

  const userMessage =
    `Context from ratings data:\n${context}\n\nQuestion: ${question}`;

  const response = await getClient().chat.completions.create({
    model: "gpt-4o",
    messages: [
      { role: "system", content: systemPrompt },
      { role: "user", content: userMessage },
    ],
    max_tokens: 500,
    temperature: 0.3,
  });

  return response.choices[0].message.content ?? "I couldn't generate a response.";
}
