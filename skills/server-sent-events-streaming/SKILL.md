---
name: server-sent-events-streaming
description: Arsitektur Server-Sent Events (SSE) performa tinggi untuk streaming LLM tokens, reconnect handling (Last-Event-ID), dan HTTP/2 multiplexing.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Streaming, SSE, LLM, Realtime, HTTP2, FastAPI, Architecture]
---

# High-Performance Server-Sent Events (SSE) for LLM Streaming (Ibra X 3.1)

Pola implementasi streaming token inferensi model AI satu arah dari server ke klien dengan latensi ultra rendah dan overhead protokol minimal dibanding WebSocket.

## 1. Implementasi FastAPI Streaming Response

```python
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse
import asyncio, json

app = FastAPI()

async def event_generator(request: Request):
    token_index = 0
    # Simulasi stream generator dari router AI
    tokens = ["Halo", " ", "operator", "!", " Ibra", " X", " 3.2", " siap", " bertugas."]
    for token in tokens:
        if await request.is_disconnected():
            print("Klien memutus sambungan stream.")
            break
        
        token_index += 1
        payload = json.dumps({"token": token, "index": token_index})
        # Format resmi SSE: id, event, data
        yield f"id: {token_index}\nevent: token\ndata: {payload}\n\n"
        await asyncio.sleep(0.04) # Simulasi latensi antar token

    yield "event: done\ndata: [DONE]\n\n"

@app.get("/v1/stream")
async def sse_endpoint(request: Request):
    return StreamingResponse(
        event_generator(request),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no" # Matikan buffering NGINX untuk streaming instan
        }
    )
```

## 2. Klien JavaScript dengan Auto-Reconnect & `Last-Event-ID`

```javascript
const eventSource = new EventSource("/v1/stream");

eventSource.addEventListener("token", (event) => {
  const data = JSON.parse(event.data);
  process.stdout.write(data.token);
});

eventSource.addEventListener("done", () => {
  console.log("\n[Stream Selesai]");
  eventSource.close();
});
```
