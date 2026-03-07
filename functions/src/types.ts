export type VectorType = "group" | "item" | "user_rating";

export interface PineconeMetadata {
  type: VectorType;
  groupId: string;
  memberIds: string[];
  itemId?: string;
  itemName?: string;
  userId?: string;
  userName?: string;
  groupName?: string;
  groupCategory?: string;
  ratingValue?: number;
  ratingScale?: number;
  textContent?: string;
}

export interface AIReference {
  type: "group" | "ratingItem";
  id: string;
  name: string;
  groupId?: string;
}

export interface QueryAIResponse {
  answer: string;
  references: AIReference[];
}
