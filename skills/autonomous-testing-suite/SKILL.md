---
name: autonomous-testing-suite
description: Framework pengujian otonom terintegrasi (unit test, mock server, snapshot comparison, dan laporan coverage).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Testing, TDD, UnitTesting, Mocking, Coverage, QA]
---

# Autonomous Test Suite & Quality Assurance (Ibra X 3.1)

Pola penulisan pengujian otomatis mandiri untuk memastikan stabilitas kode tanpa bergantung pada dependensi eksternal jaringan.

## 1. Mocking HTTP Requests (Python `unittest.mock`)

```python
import unittest
from unittest.mock import patch, MagicMock

def fetch_exchange_rate(base_currency: str) -> float:
    import urllib.request, json
    url = f"https://api.exchange.local/v1/{base_currency}"
    with urllib.request.urlopen(url) as resp:
        data = json.loads(resp.read().decode())
        return data["rate"]

class TestCurrencyService(unittest.TestCase):
    @patch("urllib.request.urlopen")
    def test_fetch_rate_success(self, mock_urlopen):
        mock_resp = MagicMock()
        mock_resp.read.return_value = b'{"rate": 15850.5}'
        mock_urlopen.return_value.__enter__.return_value = mock_resp

        rate = fetch_exchange_rate("USD")
        self.assertEqual(rate, 15850.5)

if __name__ == "__main__":
    unittest.main()
```
