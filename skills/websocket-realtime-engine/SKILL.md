---
name: websocket-realtime-engine
description: Arsitektur komunikasi real-time WebSocket performa tinggi, connection heartbeat (ping/pong), horizontal scaling dengan Redis Pub/Sub, dan binary framing.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [WebSocket, Realtime, Redis, PubSub, Concurrency, Socket, Streaming]
---

# High-Concurrency WebSocket & Real-Time Engine (Ibra X 3.1)

Pola pengembangan arsitektur gateway WebSocket dua arah yang mampu menangani puluhan ribu koneksi konkuren secara stabil dengan skalabilitas horizontal.

## 1. Mekanisme Deteksi Sambungan Putus (Heartbeat / Ping-Pong)

Mencegah koneksi zombie membebani alokasi memori file descriptor:

```typescript
import { WebSocketServer, WebSocket } from "ws";

const wss = new WebSocketServer({ port: 8080 });

interface ExtWebSocket extends WebSocket {
  isAlive: boolean;
}

wss.on("connection", (ws: ExtWebSocket) => {
  ws.isAlive = true;
  ws.on("pong", () => {
    ws.isAlive = true;
  });
});

// Interval pemeriksaan berkala setiap 30 detik
const interval = setInterval(() => {
  wss.clients.forEach((ws) => {
    const extWs = ws as ExtWebSocket;
    if (extWs.isAlive === false) {
      return extWs.terminate(); // Putus paksa koneksi mati
    }
    extWs.isAlive = false;
    extWs.ping();
  });
}, 30000);

wss.on("close", () => clearInterval(interval));
```

## 2. Skalabilitas Horizontal Lintas Node via Redis Pub/Sub

Ketika aplikasi berjalan pada beberapa kontainer di belakang load balancer, pesan disinkronkan menggunakan Redis channel:

```python
import asyncio, json
import redis.asyncio as redis

r = redis.from_url("redis://localhost:6379")

async def broadcast_listener(websocket_manager):
    pubsub = r.pubsub()
    await pubsub.subscribe("global_chat_channel")
    async for message in pubsub.listen():
        if message["type"] == "message":
            payload = json.loads(message["data"])
            await websocket_manager.broadcast_local(payload)

async def send_message_to_all_nodes(payload: dict):
    await r.publish("global_chat_channel", json.dumps(payload))
```
