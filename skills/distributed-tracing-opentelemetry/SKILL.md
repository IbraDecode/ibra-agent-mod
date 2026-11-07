---
name: distributed-tracing-opentelemetry
description: Observabilitas sistem terdistribusi (OpenTelemetry SDK, propagasi W3C TraceContext, pelacakan span antarmikroservis, dan integrasi Jaeger/Prometheus).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Observability, OpenTelemetry, OTel, Tracing, Metrics, Microservices, Jaeger]
---

# Distributed Tracing & Observability with OpenTelemetry (Ibra X 3.1)

Standar instrumentasi kode untuk melacak alur eksekusi request lintas puluhan mikroservis dengan overhead latensi mendekati nol.

## 1. Instrumentasi Otomatis Node.js / TypeScript (`tracer.ts`)

```typescript
import { NodeSDK } from "@opentelemetry/sdk-node";
import { getNodeAutoInstrumentations } from "@opentelemetry/auto-instrumentations-node";
import { OTLPTraceExporter } from "@opentelemetry/exporter-trace-otlp-http";

const sdk = new NodeSDK({
  serviceName: "ibra-billing-service",
  traceExporter: new OTLPTraceExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || "http://localhost:4318/v1/traces",
  }),
  instrumentations: [getNodeAutoInstrumentations({
    // Nonaktifkan pelacakan fs yang terlalu berisik
    "@opentelemetry/instrumentation-fs": { enabled: false },
  })],
});

sdk.start();
```

## 2. Propagasi Konteks Header Antarlayanan (W3C TraceContext)

Pastikan `traceparent` dan `tracestate` diteruskan pada setiap request keluar:

```python
from opentelemetry import trace
from opentelemetry.propagate import inject
import requests

tracer = trace.get_tracer(__name__)

def call_downstream_service(url: str, payload: dict):
    with tracer.start_as_current_span("call_downstream_service") as span:
        span.set_attribute("http.url", url)
        span.set_attribute("business.action", "charge_wallet")
        
        headers = {}
        # Injeksi traceparent ke dalam header HTTP
        inject(headers)
        
        response = requests.post(url, json=payload, headers=headers, timeout=5)
        span.set_attribute("http.status_code", response.status_code)
        return response.json()
```

## 3. Menghubungkan Log dengan Trace ID (*Log-Trace Correlation*)

Sertakan `trace_id` dan `span_id` pada setiap log terstruktur (JSON) agar insiden error dapat langsung dicocokkan dengan grafik waterfall di Jaeger atau Datadog:

```json
{
  "timestamp": "2026-11-07T11:15:00Z",
  "level": "error",
  "service": "ibra-billing-service",
  "trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
  "span_id": "00f067aa0ba902b7",
  "message": "Payment gateway timeout for order #9821"
}
```
