// Marketing seed script — populates demo data for screenshots
// Run with: node seed_marketing.mjs  (from the functions/ directory)
// Requires: android/service-account.json (Firebase service account)

import { initializeApp, cert } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const serviceAccount = JSON.parse(
  readFileSync("/Users/ashar/data/project_vantaa/group_ratings/data/v-group-ratings-4318cc51c12f.json", "utf8")
);

initializeApp({ credential: cert(serviceAccount), projectId: "v-group-ratings" });
const db = getFirestore();

// ── Helpers ───────────────────────────────────────────────────────────────────

const daysAgo = (n) => new Date(Date.now() - n * 24 * 60 * 60 * 1000);
const ts = (date) => Timestamp.fromDate(date);
const img = (id) =>
  `https://images.unsplash.com/photo-${id}?w=800&q=80&auto=format&fit=crop`;

async function setDoc(collection, id, data) {
  await db.collection(collection).doc(id).set(data);
  console.log(`  ✓ ${collection}/${id}`);
}

// ── Users ─────────────────────────────────────────────────────────────────────

const users = [
  { uid: "demo_alex", displayName: "Alex Rivera", photoURL: "https://i.pravatar.cc/150?img=33", email: "alex@demo.kretik.com" },
  { uid: "demo_sophie", displayName: "Sophie Chen", photoURL: "https://i.pravatar.cc/150?img=47", email: "sophie@demo.kretik.com" },
  { uid: "demo_marcus", displayName: "Marcus Johnson", photoURL: "https://i.pravatar.cc/150?img=12", email: "marcus@demo.kretik.com" },
  { uid: "demo_priya", displayName: "Priya Patel", photoURL: "https://i.pravatar.cc/150?img=56", email: "priya@demo.kretik.com" },
  { uid: "demo_james", displayName: "James O'Brien", photoURL: "https://i.pravatar.cc/150?img=21", email: "james@demo.kretik.com" },
  { uid: "demo_emma", displayName: "Emma Larsson", photoURL: "https://i.pravatar.cc/150?img=44", email: "emma@demo.kretik.com" },
];

console.log("\n── Writing users ──────────────────────────────────────────────");
for (const u of users) {
  await setDoc("users", u.uid, {
    uid: u.uid,
    email: u.email,
    displayName: u.displayName,
    photoURL: u.photoURL,
    emailVerified: true,
    createdAt: ts(daysAgo(120)),
    lastSignInAt: ts(daysAgo(1)),
  });
}

// ── Helpers for group/rating construction ────────────────────────────────────

function member(user, role, daysJoined) {
  return {
    userId: user.uid,
    name: user.displayName,
    role,
    joinedAt: ts(daysAgo(daysJoined)),
  };
}

function rating({ user, value, scale, comment, daysAgo: d }) {
  const now = ts(daysAgo(d));
  return {
    userId: user.uid,
    userName: user.displayName,
    ratingValue: value,
    normalizedValue: value / scale,
    comment,
    createdAt: now,
    updatedAt: now,
  };
}

function ratingItem({ id, name, description, imageId, location, scale, groupId, createdBy, ratings, daysCreated }) {
  const ratedBy = ratings.map((r) => r.userId);
  const createdAt = ts(daysAgo(daysCreated));
  return {
    id,
    name,
    description,
    imageUrl: img(imageId),
    location,
    ratingScale: scale,
    ratedBy,
    ratings,
    groupId,
    createdBy,
    createdAt,
    updatedAt: ts(daysAgo(daysCreated - 2)),
  };
}

const [alex, sophie, marcus, priya, james, emma] = users;

// ── Group 1: NYC Food Scene ───────────────────────────────────────────────────

const GROUP_FOOD = "demo_nyc_food";
const foodMembers = [alex, sophie, marcus, priya, james, emma];

console.log("\n── Writing NYC Food Scene ─────────────────────────────────────");
await setDoc("groups", GROUP_FOOD, {
  id: GROUP_FOOD,
  groupCode: "NYC123",
  name: "NYC Food Scene",
  description: "Rating the best restaurants and hidden gems across New York City",
  imageUrl: img("1414235077428-338989a2e8c0"),
  ratingItemsCount: 5,
  category: "food",
  memberIds: foodMembers.map((u) => u.uid),
  members: [
    member(alex, "admin", 90),
    member(sophie, "member", 88),
    member(marcus, "member", 85),
    member(priya, "member", 82),
    member(james, "member", 80),
    member(emma, "member", 78),
  ],
  createdAt: ts(daysAgo(90)),
  updatedAt: ts(daysAgo(2)),
});

const foodItems = [
  ratingItem({
    id: "demo_carbone",
    name: "Carbone",
    description: "Iconic Italian-American restaurant famous for its rigatoni alla vodka and dramatic atmosphere",
    imageId: "1414235077428-338989a2e8c0",
    location: "Greenwich Village, New York",
    scale: 10,
    groupId: GROUP_FOOD,
    createdBy: alex.uid,
    daysCreated: 80,
    ratings: [
      rating({ user: alex, value: 9, scale: 10, comment: "Rigatoni alla vodka is pure magic — can't stop thinking about it!", daysAgo: 75 }),
      rating({ user: sophie, value: 8, scale: 10, comment: "The atmosphere is electric and the food matches every bit of it.", daysAgo: 74 }),
      rating({ user: marcus, value: 9, scale: 10, comment: "Best Italian in NYC, no contest. The spicy rigatoni is iconic.", daysAgo: 73 }),
      rating({ user: priya, value: 7, scale: 10, comment: "Incredible experience but the portions could be bigger. Still worth it!", daysAgo: 72 }),
      rating({ user: james, value: 8, scale: 10, comment: "The tuxedo-clad waiters add to the drama. Food was absolutely delicious.", daysAgo: 71 }),
      rating({ user: emma, value: 9, scale: 10, comment: "I dream about the mozzarella in carozza. Worth every cent!", daysAgo: 70 }),
    ],
  }),
  ratingItem({
    id: "demo_le_bernardin",
    name: "Le Bernardin",
    description: "Three-Michelin-star French seafood restaurant by chef Éric Ripert",
    imageId: "1555396273-367ea4eb4db5",
    location: "Midtown Manhattan, New York",
    scale: 10,
    groupId: GROUP_FOOD,
    createdBy: sophie.uid,
    daysCreated: 70,
    ratings: [
      rating({ user: alex, value: 10, scale: 10, comment: "The barely-cooked salmon changed my understanding of what food can be.", daysAgo: 65 }),
      rating({ user: sophie, value: 9, scale: 10, comment: "Flawless from start to finish. The service is as good as the food.", daysAgo: 64 }),
      rating({ user: marcus, value: 10, scale: 10, comment: "Three Michelin stars fully earned. Every bite was an event.", daysAgo: 63 }),
      rating({ user: priya, value: 8, scale: 10, comment: "Exceptional technique but not quite my flavor profile. Still stunning.", daysAgo: 62 }),
      rating({ user: james, value: 9, scale: 10, comment: "The tasting menu is long but every single course earns its place.", daysAgo: 61 }),
      rating({ user: emma, value: 10, scale: 10, comment: "The langoustine dish alone justifies every penny. Perfection.", daysAgo: 60 }),
    ],
  }),
  ratingItem({
    id: "demo_momofuku",
    name: "Momofuku Noodle Bar",
    description: "David Chang's original noodle bar that sparked a culinary revolution",
    imageId: "1569718212165-3a8278d5f624",
    location: "East Village, New York",
    scale: 10,
    groupId: GROUP_FOOD,
    createdBy: marcus.uid,
    daysCreated: 60,
    ratings: [
      rating({ user: alex, value: 7, scale: 10, comment: "A NYC institution. The pork buns are still the best in the city.", daysAgo: 55 }),
      rating({ user: sophie, value: 8, scale: 10, comment: "Noisy and chaotic but in the best way possible. The ramen is extraordinary.", daysAgo: 54 }),
      rating({ user: marcus, value: 7, scale: 10, comment: "Good but doesn't quite live up to the hype anymore. Still worth visiting.", daysAgo: 53 }),
      rating({ user: priya, value: 9, scale: 10, comment: "The vegetarian options here are surprisingly incredible. Loved every dish.", daysAgo: 52 }),
      rating({ user: james, value: 7, scale: 10, comment: "Classic NYC ramen spot. The pork belly bun is a legend for a reason.", daysAgo: 51 }),
      rating({ user: emma, value: 8, scale: 10, comment: "The ginger scallion noodles are criminally underrated. Go for those alone.", daysAgo: 50 }),
    ],
  }),
  ratingItem({
    id: "demo_peter_luger",
    name: "Peter Luger Steakhouse",
    description: "Brooklyn's legendary cash-only steakhouse serving the finest dry-aged porterhouse since 1887",
    imageId: "1546833999-b9f581a1996d",
    location: "Williamsburg, Brooklyn",
    scale: 10,
    groupId: GROUP_FOOD,
    createdBy: james.uid,
    daysCreated: 50,
    ratings: [
      rating({ user: alex, value: 9, scale: 10, comment: "The porterhouse for two is one of the great meals of my life. Stunning.", daysAgo: 45 }),
      rating({ user: sophie, value: 10, scale: 10, comment: "The rude service is part of the charm. The steak needs no sauce — it's perfect.", daysAgo: 44 }),
      rating({ user: marcus, value: 8, scale: 10, comment: "Incredible steak but the sides let it down slightly. The schlag is a must.", daysAgo: 43 }),
      rating({ user: priya, value: 9, scale: 10, comment: "As a non-regular meat eater, I was completely converted. Transcendent.", daysAgo: 42 }),
      rating({ user: james, value: 10, scale: 10, comment: "The best steak in the world, full stop. Don't argue with me about this.", daysAgo: 41 }),
      rating({ user: emma, value: 8, scale: 10, comment: "The atmosphere is old-school Brooklyn and the steak lives up to the legend.", daysAgo: 40 }),
    ],
  }),
  ratingItem({
    id: "demo_robertas",
    name: "Roberta's Pizza",
    description: "Legendary wood-fired Neapolitan pizza in a converted warehouse in Bushwick",
    imageId: "1513104890138-7c749659a591",
    location: "Bushwick, Brooklyn",
    scale: 10,
    groupId: GROUP_FOOD,
    createdBy: emma.uid,
    daysCreated: 40,
    ratings: [
      rating({ user: alex, value: 8, scale: 10, comment: "The Bee Sting pizza with spicy soppressata and honey is absolute genius.", daysAgo: 35 }),
      rating({ user: sophie, value: 7, scale: 10, comment: "Great pizza but the wait in the garden is part of the experience. Loved it.", daysAgo: 34 }),
      rating({ user: marcus, value: 9, scale: 10, comment: "The char on the crust is flawless. Arguably the best pizza in the five boroughs.", daysAgo: 33 }),
      rating({ user: priya, value: 8, scale: 10, comment: "The margherita here makes you question every pizza you've ever eaten before.", daysAgo: 32 }),
      rating({ user: james, value: 8, scale: 10, comment: "Great vibe, great pizza, terrible parking. Worth every bit of effort.", daysAgo: 31 }),
      rating({ user: emma, value: 7, scale: 10, comment: "Solid spot but I've had better Neapolitan. Still a fantastic neighborhood gem.", daysAgo: 30 }),
    ],
  }),
];

for (const item of foodItems) {
  await setDoc("rating_items", item.id, item);
}

// ── Group 2: Movie Night Club ─────────────────────────────────────────────────

const GROUP_MOVIES = "demo_movie_night";
const movieMembers = [alex, sophie, marcus, priya, james];

console.log("\n── Writing Movie Night Club ───────────────────────────────────");
await setDoc("groups", GROUP_MOVIES, {
  id: GROUP_MOVIES,
  groupCode: "MOVIE7",
  name: "Movie Night Club",
  description: "Our group rates every film we watch together — brutal honesty required",
  imageUrl: img("1440404653325-ab127d49abc1"),
  ratingItemsCount: 4,
  category: "movies",
  memberIds: movieMembers.map((u) => u.uid),
  members: [
    member(sophie, "admin", 85),
    member(alex, "member", 84),
    member(marcus, "member", 82),
    member(priya, "member", 80),
    member(james, "member", 79),
  ],
  createdAt: ts(daysAgo(85)),
  updatedAt: ts(daysAgo(3)),
});

const movieItems = [
  ratingItem({
    id: "demo_dune2",
    name: "Dune: Part Two",
    description: "Denis Villeneuve's epic continuation of Paul Atreides' journey across Arrakis",
    imageId: "1440404653325-ab127d49abc1",
    location: "",
    scale: 10,
    groupId: GROUP_MOVIES,
    createdBy: sophie.uid,
    daysCreated: 75,
    ratings: [
      rating({ user: alex, value: 9, scale: 10, comment: "Denis Villeneuve outdid himself — absolutely epic filmmaking at its finest!", daysAgo: 70 }),
      rating({ user: sophie, value: 8, scale: 10, comment: "Visually stunning. Slightly slower than Part One but Zendaya carries the second half.", daysAgo: 69 }),
      rating({ user: marcus, value: 9, scale: 10, comment: "The Harkonnen arena scene is one of the greatest sequences in cinema history.", daysAgo: 68 }),
      rating({ user: priya, value: 9, scale: 10, comment: "Best sci-fi film in a decade. The sandworm ride alone is worth the ticket price.", daysAgo: 67 }),
      rating({ user: james, value: 7, scale: 10, comment: "Great visuals but the second half felt rushed compared to the careful pacing of part one.", daysAgo: 66 }),
    ],
  }),
  ratingItem({
    id: "demo_oppenheimer",
    name: "Oppenheimer",
    description: "Christopher Nolan's biographical thriller about the father of the atomic bomb",
    imageId: "1489599849927-2ee91cede3ba",
    location: "",
    scale: 10,
    groupId: GROUP_MOVIES,
    createdBy: alex.uid,
    daysCreated: 60,
    ratings: [
      rating({ user: alex, value: 10, scale: 10, comment: "Cillian Murphy's performance is generational. An absolute masterpiece.", daysAgo: 55 }),
      rating({ user: sophie, value: 9, scale: 10, comment: "Nolan at his absolute best. The Trinity test sequence is jaw-dropping.", daysAgo: 54 }),
      rating({ user: marcus, value: 8, scale: 10, comment: "Good film but slightly overhyped. Still a stunning technical achievement.", daysAgo: 53 }),
      rating({ user: priya, value: 10, scale: 10, comment: "Florence Pugh was robbed of an Oscar nomination. Completely stunning throughout.", daysAgo: 52 }),
      rating({ user: james, value: 9, scale: 10, comment: "Three hours flew by — that's the mark of a truly great film.", daysAgo: 51 }),
    ],
  }),
  ratingItem({
    id: "demo_poor_things",
    name: "Poor Things",
    description: "Yorgos Lanthimos' surreal feminist odyssey starring Emma Stone as Bella Baxter",
    imageId: "1478720568477-152d9b164e26",
    location: "",
    scale: 10,
    groupId: GROUP_MOVIES,
    createdBy: priya.uid,
    daysCreated: 45,
    ratings: [
      rating({ user: alex, value: 8, scale: 10, comment: "Bizarre, beautiful, and unlike anything else. Emma Stone is absolutely phenomenal.", daysAgo: 40 }),
      rating({ user: sophie, value: 7, scale: 10, comment: "The visual style is incredible but the story isn't for everyone. Divisive but daring.", daysAgo: 39 }),
      rating({ user: marcus, value: 9, scale: 10, comment: "Yorgos Lanthimos at peak weirdness — and I mean that as the highest compliment.", daysAgo: 38 }),
      rating({ user: priya, value: 7, scale: 10, comment: "More interesting as a concept than as a film but still absolutely worth watching.", daysAgo: 37 }),
      rating({ user: james, value: 8, scale: 10, comment: "The fish-eye lens aesthetic is polarizing but I was thoroughly entertained throughout.", daysAgo: 36 }),
    ],
  }),
  ratingItem({
    id: "demo_past_lives",
    name: "Past Lives",
    description: "Celine Song's heartbreaking debut about love, identity, and the roads not taken",
    imageId: "1524985069026-dd778a71c7b4",
    location: "",
    scale: 10,
    groupId: GROUP_MOVIES,
    createdBy: marcus.uid,
    daysCreated: 30,
    ratings: [
      rating({ user: alex, value: 9, scale: 10, comment: "One of the most emotionally devastating films I've ever seen. Absolutely perfect.", daysAgo: 25 }),
      rating({ user: sophie, value: 8, scale: 10, comment: "Greta Lee is extraordinary. The final scene in the taxi completely wrecked me.", daysAgo: 24 }),
      rating({ user: marcus, value: 7, scale: 10, comment: "Beautiful but a bit too slow for my taste. Still an undeniably affecting film.", daysAgo: 23 }),
      rating({ user: priya, value: 10, scale: 10, comment: "This film made me cry for an hour after it ended. An absolute masterpiece of restraint.", daysAgo: 22 }),
      rating({ user: james, value: 9, scale: 10, comment: "Celine Song is a generational talent. Can't wait to see what she does next.", daysAgo: 21 }),
    ],
  }),
];

for (const item of movieItems) {
  await setDoc("rating_items", item.id, item);
}

// ── Group 3: Tech Essentials ──────────────────────────────────────────────────

const GROUP_TECH = "demo_tech_essentials";
const techMembers = [alex, marcus, priya, emma];

console.log("\n── Writing Tech Essentials ────────────────────────────────────");
await setDoc("groups", GROUP_TECH, {
  id: GROUP_TECH,
  groupCode: "TECH42",
  name: "Tech Essentials",
  description: "Honest ratings of the gear we actually use every day",
  imageUrl: img("1517336714731-489689fd1ca8"),
  ratingItemsCount: 4,
  category: "technology",
  memberIds: techMembers.map((u) => u.uid),
  members: [
    member(marcus, "admin", 70),
    member(alex, "member", 68),
    member(priya, "member", 65),
    member(emma, "member", 62),
  ],
  createdAt: ts(daysAgo(70)),
  updatedAt: ts(daysAgo(5)),
});

const techItems = [
  ratingItem({
    id: "demo_macbook_m3",
    name: "MacBook Pro M3",
    description: "Apple's professional laptop with the groundbreaking M3 chip and stunning Liquid Retina XDR display",
    imageId: "1517336714731-489689fd1ca8",
    location: "",
    scale: 5,
    groupId: GROUP_TECH,
    createdBy: marcus.uid,
    daysCreated: 60,
    ratings: [
      rating({ user: alex, value: 5, scale: 5, comment: "The M3 chip is absolutely insane — my projects compile in seconds now.", daysAgo: 55 }),
      rating({ user: marcus, value: 4, scale: 5, comment: "Performance is unreal but the price point is genuinely hard to justify for most users.", daysAgo: 54 }),
      rating({ user: priya, value: 5, scale: 5, comment: "Best laptop I've ever owned by a significant margin. The battery lasts all day easily.", daysAgo: 53 }),
      rating({ user: emma, value: 4, scale: 5, comment: "Runs completely cool and silent even under heavy loads. Truly impressive engineering.", daysAgo: 52 }),
    ],
  }),
  ratingItem({
    id: "demo_sony_wh1000xm5",
    name: "Sony WH-1000XM5",
    description: "Industry-leading noise cancelling headphones with exceptional audio quality and 30-hour battery",
    imageId: "1505740420928-5e560c06d30e",
    location: "",
    scale: 5,
    groupId: GROUP_TECH,
    createdBy: alex.uid,
    daysCreated: 50,
    ratings: [
      rating({ user: alex, value: 5, scale: 5, comment: "Best noise cancelling headphones on the market — full stop. I can't go back.", daysAgo: 45 }),
      rating({ user: marcus, value: 5, scale: 5, comment: "These completely transformed how I work from cafes and co-working spaces.", daysAgo: 44 }),
      rating({ user: priya, value: 4, scale: 5, comment: "Sound quality is excellent but the fit isn't perfect for very long sessions.", daysAgo: 43 }),
      rating({ user: emma, value: 5, scale: 5, comment: "The ANC is pure sorcery. I can hold calls in the noisiest environments now.", daysAgo: 42 }),
    ],
  }),
  ratingItem({
    id: "demo_ipad_pro_m4",
    name: "iPad Pro M4",
    description: "Apple's most powerful iPad with M4 chip and tandem OLED display — laptop thin",
    imageId: "1544244015-0df4b3ffc6b0",
    location: "",
    scale: 5,
    groupId: GROUP_TECH,
    createdBy: priya.uid,
    daysCreated: 35,
    ratings: [
      rating({ user: alex, value: 4, scale: 5, comment: "Almost replaced my laptop completely for travel. The OLED display is absolutely gorgeous.", daysAgo: 30 }),
      rating({ user: marcus, value: 5, scale: 5, comment: "With the Magic Keyboard attached it's a genuine laptop replacement for my workflow.", daysAgo: 29 }),
      rating({ user: priya, value: 4, scale: 5, comment: "Great device but iPadOS still limits what you can truly do with it. So much potential.", daysAgo: 28 }),
      rating({ user: emma, value: 5, scale: 5, comment: "The tandem OLED display is the most stunning screen I've ever seen on any device.", daysAgo: 27 }),
    ],
  }),
  ratingItem({
    id: "demo_apple_watch_ultra2",
    name: "Apple Watch Ultra 2",
    description: "Apple's most rugged and capable smartwatch with precision dual-frequency GPS and 60-hour battery",
    imageId: "1546868871-7041f2a55e12",
    location: "",
    scale: 5,
    groupId: GROUP_TECH,
    createdBy: emma.uid,
    daysCreated: 20,
    ratings: [
      rating({ user: alex, value: 4, scale: 5, comment: "Incredibly rugged and the battery life finally doesn't disappoint for long adventures.", daysAgo: 15 }),
      rating({ user: marcus, value: 4, scale: 5, comment: "The precision GPS is perfect for my trail runs. Worth every single penny.", daysAgo: 14 }),
      rating({ user: priya, value: 5, scale: 5, comment: "The Action button is a total game-changer for workouts. I love this watch.", daysAgo: 13 }),
      rating({ user: emma, value: 4, scale: 5, comment: "The titanium build feels incredibly premium but it's quite large on smaller wrists.", daysAgo: 12 }),
    ],
  }),
];

for (const item of techItems) {
  await setDoc("rating_items", item.id, item);
}

// ── Group 4: Weekend Wanderers ────────────────────────────────────────────────

const GROUP_TRAVEL = "demo_weekend_wanderers";
const travelMembers = [alex, sophie, marcus, james, emma];

console.log("\n── Writing Weekend Wanderers ──────────────────────────────────");
await setDoc("groups", GROUP_TRAVEL, {
  id: GROUP_TRAVEL,
  groupCode: "WANDER",
  name: "Weekend Wanderers",
  description: "Rating every destination we explore together — the good, the great, and the unforgettable",
  imageUrl: img("1533105079780-92b9be482077"),
  ratingItemsCount: 5,
  category: "travel",
  memberIds: travelMembers.map((u) => u.uid),
  members: [
    member(emma, "admin", 75),
    member(alex, "member", 74),
    member(sophie, "member", 72),
    member(marcus, "member", 70),
    member(james, "member", 68),
  ],
  createdAt: ts(daysAgo(75)),
  updatedAt: ts(daysAgo(4)),
});

const travelItems = [
  ratingItem({
    id: "demo_amalfi_coast",
    name: "Amalfi Coast",
    description: "Dramatic Italian coastline of cliffside villages, turquoise waters, and legendary seafood",
    imageId: "1533105079780-92b9be482077",
    location: "Campania, Italy",
    scale: 10,
    groupId: GROUP_TRAVEL,
    createdBy: emma.uid,
    daysCreated: 65,
    ratings: [
      rating({ user: alex, value: 10, scale: 10, comment: "Driving the Amalfi Drive at sunset is the most beautiful thing I have ever seen.", daysAgo: 60 }),
      rating({ user: sophie, value: 9, scale: 10, comment: "The lemon granita in Positano is worth the trip alone. Absolute heaven.", daysAgo: 59 }),
      rating({ user: marcus, value: 8, scale: 10, comment: "Stunning views but the tourist crowds in peak season are genuinely overwhelming.", daysAgo: 58 }),
      rating({ user: james, value: 10, scale: 10, comment: "Ravello stole my heart completely. I could have stayed there for months.", daysAgo: 57 }),
      rating({ user: emma, value: 9, scale: 10, comment: "Every single corner is a postcard. Truly one of the most beautiful places on earth.", daysAgo: 56 }),
    ],
  }),
  ratingItem({
    id: "demo_santorini",
    name: "Santorini",
    description: "Iconic Greek island known for its white-washed architecture, caldera views, and legendary sunsets",
    imageId: "1506905925346-21bda4d32df4",
    location: "Cyclades, Greece",
    scale: 10,
    groupId: GROUP_TRAVEL,
    createdBy: sophie.uid,
    daysCreated: 55,
    ratings: [
      rating({ user: alex, value: 9, scale: 10, comment: "Oia at sunset is everything you imagined and then somehow even more beautiful.", daysAgo: 50 }),
      rating({ user: sophie, value: 10, scale: 10, comment: "The caldera views from Fira left me completely and utterly speechless!", daysAgo: 49 }),
      rating({ user: marcus, value: 9, scale: 10, comment: "It's touristy but genuinely beautiful. The white architecture is truly iconic.", daysAgo: 48 }),
      rating({ user: james, value: 8, scale: 10, comment: "Good but honestly a bit too crowded and expensive for what you actually get.", daysAgo: 47 }),
      rating({ user: emma, value: 10, scale: 10, comment: "Swimming in the caldera with those volcano views — a completely unreal experience!", daysAgo: 46 }),
    ],
  }),
  ratingItem({
    id: "demo_kyoto",
    name: "Kyoto",
    description: "Japan's ancient imperial capital with thousands of temples, traditional tea houses, and geisha districts",
    imageId: "1528360983277-13d401cdc186",
    location: "Kansai, Japan",
    scale: 10,
    groupId: GROUP_TRAVEL,
    createdBy: alex.uid,
    daysCreated: 45,
    ratings: [
      rating({ user: alex, value: 10, scale: 10, comment: "Arashiyama bamboo grove at 6am — literally no words for how magical it actually is.", daysAgo: 40 }),
      rating({ user: sophie, value: 9, scale: 10, comment: "The ryokan experience in Gion was everything I dreamed of and somehow even more.", daysAgo: 39 }),
      rating({ user: marcus, value: 10, scale: 10, comment: "Fushimi Inari at night is one of the greatest experiences of my entire life.", daysAgo: 38 }),
      rating({ user: james, value: 9, scale: 10, comment: "The zen gardens completely changed how I think about space, stillness, and beauty.", daysAgo: 37 }),
      rating({ user: emma, value: 8, scale: 10, comment: "Beautiful and profoundly serene but the humidity in summer was really challenging.", daysAgo: 36 }),
    ],
  }),
  ratingItem({
    id: "demo_patagonia",
    name: "Patagonia",
    description: "South America's wild frontier of jagged peaks, ancient glaciers, and untouched wilderness",
    imageId: "1501854140801-50d01698950b",
    location: "Chile & Argentina",
    scale: 10,
    groupId: GROUP_TRAVEL,
    createdBy: marcus.uid,
    daysCreated: 30,
    ratings: [
      rating({ user: alex, value: 8, scale: 10, comment: "Torres del Paine National Park looks like another planet. Unbelievably epic.", daysAgo: 25 }),
      rating({ user: sophie, value: 9, scale: 10, comment: "The glaciers are melting fast — everyone needs to see Perito Moreno now.", daysAgo: 24 }),
      rating({ user: marcus, value: 10, scale: 10, comment: "The most raw, untouched landscape I have ever experienced. Genuinely life-changing.", daysAgo: 23 }),
      rating({ user: james, value: 8, scale: 10, comment: "Incredible but the wind nearly knocked me clean off the W Trek. Prepare accordingly.", daysAgo: 22 }),
      rating({ user: emma, value: 9, scale: 10, comment: "Camping under those stars with glacier sounds all around was completely unforgettable.", daysAgo: 21 }),
    ],
  }),
  ratingItem({
    id: "demo_marrakech",
    name: "Marrakech",
    description: "Morocco's magical imperial city of ancient medinas, vibrant souks, and stunning riads",
    imageId: "1489493585363-d69421e0edd3",
    location: "Morocco",
    scale: 10,
    groupId: GROUP_TRAVEL,
    createdBy: james.uid,
    daysCreated: 15,
    ratings: [
      rating({ user: alex, value: 9, scale: 10, comment: "Getting lost in the medina is the entire point — and it is completely magical.", daysAgo: 10 }),
      rating({ user: sophie, value: 8, scale: 10, comment: "The Majorelle Garden is absolute heaven. Those electric blue walls are stunning.", daysAgo: 9 }),
      rating({ user: marcus, value: 9, scale: 10, comment: "The souks and spices and sounds are overwhelming in the very best possible way.", daysAgo: 8 }),
      rating({ user: james, value: 10, scale: 10, comment: "The riad we stayed in was the most beautiful place I have ever slept. A perfect 10.", daysAgo: 7 }),
      rating({ user: emma, value: 8, scale: 10, comment: "Djemaa el-Fna square at night is the most alive place I have ever been.", daysAgo: 6 }),
    ],
  }),
];

for (const item of travelItems) {
  await setDoc("rating_items", item.id, item);
}

// ── App Config: Mirror Access ─────────────────────────────────────────────────

console.log("\n── Writing app_config/mirror_access ──────────────────────────");
await setDoc("app_config", "mirror_access", {
  allowedEmails: ["asharalijamshaid@gmail.com"], // ← Replace with your real email before running
});

// ── Summary ───────────────────────────────────────────────────────────────────

console.log(`
── Done ──────────────────────────────────────────────────────
  Users:         ${users.length}
  Groups:        4  (NYC Food Scene, Movie Night Club, Tech Essentials, Weekend Wanderers)
  Rating items:  18
  Ratings:       ${6 * 5 + 5 * 4 + 4 * 4 + 5 * 5} individual ratings
  Mirror access: app_config/mirror_access (update allowedEmails!)
──────────────────────────────────────────────────────────────
`);
