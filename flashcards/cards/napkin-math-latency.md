---
name = "Napkin Math: Latency"
author = "Simon Eskildsen"
source_url = "https://github.com/sirupsen/napkin-math"
---

C:
Operation: Sequential Memory R/W (64 bytes)

Latency: [0.5 ns]

---

C:
Operation: Sequential Memory R/W (64 bytes): Single Thread No SIMD

Latency: [0.5 ns]

---

C:
Operation: Sequential Memory R/W (64 bytes): Single Thread SIMD

Latency: [0.5 ns]

---

C:
Operation: Sequential Memory R/W (64 bytes): Threaded No SIMD

Latency: [0.5 ns]

---

C:
Operation: Sequential Memory R/W (64 bytes): Threaded SIMD

Latency: [0.5 ns]

---

C:
Operation: Network Same-Zone

Throughput: [10 GiB/s]

---

C:
Operation: Network Same-Zone: Inside VPC

Throughput: [10 GiB/s]

---

C:
Operation: Network Same-Zone: Outside VPC

Throughput: [3 GiB/s]

---

C:
Operation: Hashing not crypto-safe (64 bytes)

Latency: [25 ns]

---

C:
Operation: Random Memory R/W (64 bytes)

Latency: [50 ns]

---

C:
Operation: Fast Serialization

Throughput: [1 GiB/s]

---

C:
Operation: Fast Deserialization

Throughput: [1 GiB/s]

---

C:
Operation: System Call

Latency: [500 ns]

---

C:
Operation: Hashing crypto-safe (64 bytes)

Latency: [100 ns]

---

C:
Operation: Sequential SSD read (8 KiB)

Latency: [1 μs]

---

C:
Operation: Context Switch

Latency: [10 μs]

---

C:
Operation: Sequential SSD write -fsync (8KiB)

Latency: [10 μs]

---

C:
Operation: TCP Echo Server (32 KiB)

Latency: [10 μs]

---

C:
Operation: Decompression

Throughput: [1 GiB/s]

---

C:
Operation: Compression

Throughput: [500 MiB/s]

---

C:
Operation: Sequential SSD write +fsync (8KiB)

Latency: [1 ms]

---

C:
Operation: Sorting (64-bit integers)

Throughput: [200 MiB/s]

---

C:
Operation: Sequential HDD Read (8 KiB)

Latency: [10 ms]

---

C:
Operation: Blob Storage GET 1 conn

Latency: [50 ms]

---

C:
Operation: Blob Storage GET n conn (offsets)

Latency: [50 ms]

---

C:
Operation: Blob Storage PUT 1 conn

Latency: [50 ms]

---

C:
Operation: Blob Storage PUT n conn (multipart)

Latency: [150 ms]

---

C:
Operation: Random SSD Read (8 KiB)

Latency: [100 μs]

---

C:
Operation: Serialization

Throughput: [100 MiB/s]

---

C:
Operation: Deserialization

Throughput: [100 MiB/s]

---

C:
Operation: Proxy: Envoy/ProxySQL/Nginx/HAProxy

Latency: [50 μs]

---

C:
Operation: Network within same region

Latency: [250 μs]

---

C:
Operation: Premium network within zone/VPC

Latency: [250 μs]

---

C:
Operation: MySQL/Memcached/Redis Query

Latency: [500 μs]

---

C:
Operation: Random HDD Read (8 KiB)

Latency: [10 ms]

---

C:
Operation: Network NA Central <-> East

Latency: [25 ms]

---

C:
Operation: Network NA Central <-> West

Latency: [40 ms]

---

C:
Operation: Network NA East <-> West

Latency: [60 ms]

---

C:
Operation: Network EU West <-> NA East

Latency: [80 ms]

---

C:
Operation: Network EU West <-> NA Central

Latency: [100 ms]

---

C:
Operation: Network NA West <-> Singapore

Latency: [180 ms]

---

C:
Operation: Network EU West <-> Singapore

Latency: [160 ms]
