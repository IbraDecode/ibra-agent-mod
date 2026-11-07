---
name: graphql-api-design
description: Perancangan skema GraphQL performa tinggi (mitigasi N+1 problem via DataLoader, pembatasan kedalaman query, dan arsitektur federasi).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [GraphQL, API, DataLoader, Architecture, Performance, Security]
---

# High-Performance GraphQL API Design (Ibra X 3.1)

Pedoman perancangan API GraphQL skala besar yang aman dari eksploitasi rekursif, efisien dalam eksekusi basis data, dan mudah dipelihara.

## 1. Mitigasi N+1 Problem Menggunakan DataLoader

Jangan pernah melakukan query database berulang di dalam field resolver:

```typescript
import DataLoader from "dataloader";

// Batching & Caching query pengguna berdasarkan daftar ID
const userLoader = new DataLoader<string, User>(async (userIds) => {
  const users = await db.query(
    "SELECT * FROM users WHERE id = ANY($1)", 
    [userIds]
  );
  const userMap = new Map(users.map((u) => [u.id, u]));
  return userIds.map((id) => userMap.get(id) || null);
});

// Resolver menjadi O(1) database query terlepas dari jumlah post
const resolvers = {
  Post: {
    author: (parent: Post) => userLoader.load(parent.authorId),
  },
};
```

## 2. Pengamanan Query Depth & Complexity Limiting

Mencegah serangan DoS melalui query sarang tanpa batas (*nested recursive queries*):

```typescript
import { createComplexityLimitRule } from "graphql-validation-complexity";
import depthLimit from "graphql-depth-limit";

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [
    depthLimit(5), // Batasi kedalaman sarang maksimal 5 tingkat
    createComplexityLimitRule(1000, {
      onCost: (cost) => console.log("Query cost:", cost),
      formatErrorMessage: (cost) => `Query terlalu kompleks (Biaya: ${cost}, Batas: 1000)`,
    }),
  ],
});
```

## 3. Pagination Standar Relay Cursor-Based

Gunakan cursor daripada offset untuk performa tinggi pada dataset besar:
```graphql
type Query {
  articles(first: Int, after: String): ArticleConnection!
}

type ArticleConnection {
  edges: [ArticleEdge!]!
  pageInfo: PageInfo!
}

type ArticleEdge {
  cursor: String!
  node: Article!
}

type PageInfo {
  hasNextPage: Boolean!
  endCursor: String
}
```
