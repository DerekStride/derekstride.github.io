---
name = "Kubernetes Probes"
source_url = "https://kubernetes.io/docs/concepts/workloads/pods/probes/"
---

Q: What does a Kubernetes `startupProbe` do?

A: It holds off the other probes while the app boots. Liveness and readiness probes don't run until the startup probe succeeds once, and it doesn't run again after that. If it fails `failureThreshold` times in a row, the kubelet kills the container and `restartPolicy` decides what happens next.

Startup budget: `initialDelaySeconds + failureThreshold × periodSeconds`

---

Q: What does a Kubernetes `readinessProbe` do?

A: **It decides whether the Pod gets traffic.**

- On failure, the container is marked not Ready and the Pod IP is removed from matching Service EndpointSlices.
- The container is **not** restarted.
- It runs for the container's whole lifetime, so a Pod can go back and forth between Ready and not Ready.

---

Q: What does a Kubernetes `livenessProbe` do?

A: It decides whether the container needs a restart. After `failureThreshold` consecutive failures, the kubelet kills the container and `restartPolicy` applies. It runs for the container's whole lifetime and doesn't wait for readiness. Only use it for states the app can't recover from on its own, like a deadlock.

---

C:
`successThreshold` must be `1` for [liveness and startup] probes.

---

Q: What are the four probe mechanisms, and when does `httpGet` count as success?

A: `exec`, `httpGet`, `tcpSocket`, `grpc`. Each probe uses exactly one. `httpGet` succeeds when `200 <= status < 400`.

---

Q: A `startupProbe` has `periodSeconds: 10` and `failureThreshold: 30`. How long can the app take to start?

A: 300s (5 minutes). After that the container is killed.

---

Q: Why is `initialDelaySeconds: 0` safe on a `readinessProbe` but risky on a `livenessProbe`?

A: A failed readiness check only keeps the Pod out of endpoints. The kubelet keeps probing, so there is no deadline. A failed liveness check kills the container, so a slow starter gets only `failureThreshold × periodSeconds` (30s by default) before it is restarted. Use a `startupProbe` for slow starters.

---

Q: What is a common pattern for using liveness and readiness probes together?

A: Point both at the same cheap endpoint, but give liveness a higher `failureThreshold`. The Pod then stops getting traffic before it gets killed.
