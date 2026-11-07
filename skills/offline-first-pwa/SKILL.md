---
name: offline-first-pwa
description: Arsitektur Progressive Web App (PWA) offline-first (Service Worker caching strategies, IndexedDB local persistence, dan mutation replay sync).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Frontend, PWA, ServiceWorker, Offline-First, IndexedDB, Web]
---

# Offline-First PWA Architecture (Ibra X 3.1)

Pola pengembangan aplikasi web tangguh yang tetap berfungsi normal tanpa koneksi internet dan melakukan sinkronisasi otomatis saat online kembali.

## 1. Strategi Service Worker Caching (Workbox / Pure JS)

```javascript
// sw.js - Strategi Caching Berjenjang
const STATIC_CACHE = "ibra-static-v1";
const DATA_CACHE = "ibra-data-v1";

self.addEventListener("fetch", (event) => {
  const url = new URL(event.request.url);

  // 1. Aset Statis (JS, CSS, Gambar): Cache First
  if (url.origin === location.origin && (url.pathname.endsWith(".js") || url.pathname.endsWith(".css"))) {
    event.respondWith(
      caches.match(event.request).then((cached) => cached || fetch(event.request))
    );
    return;
  }

  // 2. Data API: Network First dengan Fallback Cache
  if (url.pathname.startsWith("/api/")) {
    event.respondWith(
      fetch(event.request)
        .then((response) => {
          const clone = response.clone();
          caches.open(DATA_CACHE).then((cache) => cache.put(event.request, clone));
          return response;
        })
        .catch(() => caches.match(event.request))
    );
  }
});
```

## 2. Antrean Mutasi Offline (*Mutation Sync Queue*)

Simpan perubahan data pengguna ke IndexedDB saat offline, lalu kirim ulang saat koneksi internet pulih:

```javascript
import { openDB } from "idb";

const dbPromise = openDB("ibra-offline-db", 1, {
  upgrade(db) {
    db.createObjectStore("mutation-queue", { autoIncrement: true });
  },
});

async function saveOfflineAction(action, payload) {
  const db = await dbPromise;
  await db.add("mutation-queue", { action, payload, timestamp: Date.now() });
}

// Dengarkan pemulihan koneksi internet
window.addEventListener("online", async () => {
  const db = await dbPromise;
  const mutations = await db.getAll("mutation-queue");
  for (const m of mutations) {
    try {
      await fetch(m.action, { method: "POST", body: JSON.stringify(m.payload) });
    } catch (e) {
      console.warn("Gagal replay mutasi:", e);
    }
  }
  await db.clear("mutation-queue");
});
```
