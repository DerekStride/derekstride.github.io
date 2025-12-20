---
layout: post
title: Serverless Flashcards on Cloudflare
excerpt: >
  A flashcard app on Cloudflare's edge: Pages for the frontend, Functions for spaced repetition logic, D1 for progress, and plain-text cards in git.
---

A flashcard app that runs entirely on Cloudflare's edge infrastructure. No servers to manage, globally fast, and cards authored as plain text files.

## The Stack

- **Cloudflare Pages** – serves the static frontend (HTML/CSS/JS)
- **Pages Functions** – server-side logic for drill sessions, spaced repetition scheduling, progress tracking
- **D1** – Cloudflare's SQLite database stores card progress and review history
- **R2** – object storage for media (images, audio) if cards reference them

## Why Edge-First

Traditional flashcard apps either run locally (like Anki) or require a backend server. This approach:

- Runs at the edge – low latency anywhere in the world
- Zero infrastructure – no VPS, no Docker, no maintenance
- Pay-per-use – essentially free for personal flashcard volumes
- Cards stay in version control – author with any text editor, track changes with git

## The Card Format

Borrowed from [hashcards](https://github.com/eudoxia0/hashcards), a plain-text spaced repetition system. Cards are written in markdown files using a lightweight notation:

**Question/Answer cards:**
```
Q: What is the fundamental charge?
A: The magnitude of the electric charge of a proton or electron (~1.6 × 10⁻¹⁹ C).
```

**Cloze deletion cards:**
```
C: The [mitochondria] is the [powerhouse] of the cell.
```

Cards are identified by the hash of their content. Edit a card, and it's treated as a new card (progress resets). This keeps things simple and content-addressable.

## What D1 and R2 Are

**D1** is Cloudflare's managed SQLite database. It uses standard SQLite syntax, runs at the edge, and integrates with Pages Functions. Each database can hold up to 10GB – more than enough for flashcard progress data.

**R2** is Cloudflare's object storage (similar to S3, but with no egress fees). Useful if cards include images or audio files that shouldn't live in the git repo.

## Spaced Repetition

The app would implement [FSRS](https://github.com/open-spaced-repetition/fsrs4anki) (Free Spaced Repetition Scheduler), the same algorithm hashcards uses. FSRS is a modern alternative to SM-2, optimizing review intervals based on card difficulty and user performance.

Progress data stored in D1:
- Card hash (primary key)
- Stability and difficulty parameters
- Due date
- Review count and history

## Open Questions

- Authentication – how to identify users? Cloudflare Access? Simple password? Public but isolated by URL?
- Card sync – should cards be fetched from the repo at build time, or stored in D1/R2?
- Offline support – service workers for offline drilling, sync when back online?
