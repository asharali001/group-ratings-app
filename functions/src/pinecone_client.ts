import { Pinecone, RecordMetadata } from "@pinecone-database/pinecone";
import { PineconeMetadata } from "./types";
import { embedText } from "./openai_client";

const INDEX_NAME = "group-ratings";

let _pinecone: Pinecone | null = null;

function getClient(): Pinecone {
  if (!_pinecone) {
    const apiKey = process.env.PINECONE_API_KEY;
    if (!apiKey) throw new Error("PINECONE_API_KEY environment variable not set");
    _pinecone = new Pinecone({ apiKey });
  }
  return _pinecone;
}

function getIndex() {
  return getClient().index<RecordMetadata>(INDEX_NAME);
}

export async function upsertVector(
  id: string,
  text: string,
  metadata: PineconeMetadata
): Promise<void> {
  const values = await embedText(text);
  await getIndex().upsert([
    {
      id,
      values,
      metadata: { ...metadata, textContent: text } as RecordMetadata,
    },
  ]);
}

export async function queryVectors(
  userId: string,
  questionEmbedding: number[],
  topK = 10
): Promise<Array<{ id: string; score: number; metadata: PineconeMetadata }>> {
  const results = await getIndex().query({
    vector: questionEmbedding,
    topK,
    includeMetadata: true,
    filter: { memberIds: { $in: [userId] } },
  });

  return (results.matches ?? []).map((match) => ({
    id: match.id,
    score: match.score ?? 0,
    metadata: match.metadata as unknown as PineconeMetadata,
  }));
}

export async function deleteVector(id: string): Promise<void> {
  await getIndex().deleteOne(id);
}

export async function deleteVectorsByPrefix(prefix: string): Promise<void> {
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
    const ids = (results.matches ?? []).map((m) => m.id);
    if (ids.length > 0) {
      await getIndex().deleteMany(ids);
    }
  } catch {
    // Non-critical — vectors will become stale but won't affect correctness
  }
}
