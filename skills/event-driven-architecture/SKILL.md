---
name: event-driven-architecture
description: Pola arsitektur berbasis event (RabbitMQ, Kafka, Redis Streams, Transactional Outbox pattern, idempotency, dan Dead Letter Queues).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Architecture, Event-Driven, Kafka, RabbitMQ, Redis, Microservices, Outbox]
---

# Event-Driven Architecture & Resilient Messaging (Ibra X 3.1)

Pola desain sistem terdistribusi asinkron untuk menjamin konsistensi data (*eventual consistency*) dan keandalan pemrosesan pesan tanpa data hilang.

## 1. Pola Transactional Outbox (Mencegah Dual-Write Hazard)

Jangan pernah menulis ke basis data lalu langsung mem-publish ke message broker dalam satu fungsi tanpa transaksi terpadu:

```sql
-- 1. Simpan perubahan bisnis dan pesan outbox dalam 1 transaksi DB lokal
BEGIN;

INSERT INTO orders (id, customer_id, total, status)
VALUES ('ord_123', 'cust_99', 150000, 'CREATED');

INSERT INTO outbox_events (id, aggregate_type, aggregate_id, event_type, payload, status)
VALUES (
    'evt_abc', 
    'ORDER', 
    'ord_123', 
    'OrderCreated', 
    '{"id":"ord_123", "total":150000}', 
    'PENDING'
);

COMMIT;
```

Sebuah proses *worker relay* terpisah membaca tabel `outbox_events` dan mem-publish pesan ke broker, lalu menandai statusnya sebagai `PUBLISHED`.

## 2. Konsumen Idempoten (*Idempotent Consumer*)

Pesan broker dapat terkirim lebih dari satu kali (*at-least-once delivery*). Konsumen wajib melacak ID pesan yang telah diproses:

```python
import redis

r = redis.Redis(host='localhost', port=6379, db=0)

def handle_incoming_event(event_id: str, payload: dict):
    # Gunakan SETNX dengan TTL sebagai lock deduplikasi pesan
    is_new = r.set(f"processed_event:{event_id}", "1", nx=True, ex=86400)
    if not is_new:
        print(f"Pesan {event_id} sudah pernah diproses. Melewati (Deduplicated).")
        return

    # Eksekusi logika bisnis nyata
    process_order(payload)
```

## 3. Strategi Dead Letter Queue (DLQ)

Pesan yang gagal diproses setelah sejumlah percobaan ulang (*retry*) dipindahkan ke antrean DLQ untuk diinvestigasi tanpa memblokir antrean utama:

```python
MAX_RETRIES = 3

def process_message(msg):
    try:
        execute_task(msg.payload)
        msg.ack()
    except Exception as err:
        retry_count = msg.headers.get("x-retry-count", 0) + 1
        if retry_count > MAX_RETRIES:
            send_to_dead_letter_queue(msg, reason=str(err))
            msg.ack() # Ack dari queue utama agar antrean tetap berjalan
        else:
            msg.requeue_with_delay(backoff_sec=2 ** retry_count)
```
