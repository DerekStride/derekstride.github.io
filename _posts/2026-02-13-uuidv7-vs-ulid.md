---
layout: post
title: UUIDv7 vs ULID
excerpt: >
  Both UUIDv7 and ULID solve the same problem: time-sortable, globally unique identifiers. They share the same
  fundamental structure but differ in standardization, encoding, and ecosystem support. Here's how they compare and when
  to use each.
---

If you've been building systems that need unique identifiers, you've probably run into the limitations of UUIDv4. Random
UUIDs fragment B-tree indexes, cause excessive page splits, and destroy cache locality in databases. Two formats emerged
to fix this by putting a timestamp first: ULID (2016) and UUIDv7 (2024, via RFC 9562). They're remarkably similar in
structure but differ in important ways.

## The Problem They Both Solve

UUIDv4 generates fully random 128-bit values. When used as a primary key, each insert targets a random location in a
B-tree index. Sequential IDs cause 10-20 page splits per million records; UUIDv4 causes 5,000-10,000+. Index pages
average ~69% full instead of ~90%, wasting disk space and I/O. Buffer cache effectiveness drops because hot pages are
spread across the entire index.

Both UUIDv7 and ULID fix this by putting a millisecond-precision Unix timestamp in the most significant bits. New IDs
append to the end of the index, just like auto-incrementing integers, while retaining 128-bit global uniqueness.

## Structure

Both formats are 128 bits. Both dedicate the leading 48 bits to a Unix epoch millisecond timestamp. The difference is
in how they use the remaining 80 bits.

### ULID

```
 01AN4Z07BY      79KA1307SR9X4MV3
|----------|    |----------------|
 Timestamp          Randomness
  48 bits            80 bits
```

All 80 remaining bits are available for randomness. No bits are reserved for format metadata.

### UUIDv7

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           unix_ts_ms                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          unix_ts_ms           |  ver  |       rand_a          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|var|                        rand_b                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                            rand_b                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

Six bits are consumed by the version (`ver`, 4 bits, set to `0111`) and variant (`var`, 2 bits, set to `10`) fields.
That leaves 74 bits for randomness: 12 in `rand_a` and 62 in `rand_b`. Those 6 bits are the cost of UUID format
compliance.

## Encoding

This is where the two formats diverge most visibly.

**ULID** uses Crockford's Base32 encoding (5 bits per character), producing a 26-character string:

```
01ARZ3NDEKTSV4RRFFQ69G5FAV
```

The alphabet (`0123456789ABCDEFGHJKMNPQRSTVWXYZ`) omits I, L, O, and U to avoid visual ambiguity. It's case
insensitive, contains no hyphens or special characters, and is URL-safe.

**UUIDv7** uses the standard UUID hex-with-dashes encoding, producing a 36-character string:

```
01932c08-e690-7584-b945-253de779b977
```

The `7` after the second dash is the version nibble. This format is instantly recognizable as a UUID by any system that
handles UUIDs.

## Monotonicity

Both specs address what happens when multiple IDs are generated within the same millisecond.

**ULID** increments the random component by 1 in the least significant bit position. If the 80-bit random space
overflows within a single millisecond, generation fails. In practice, 2^80 IDs per millisecond is not a realistic
concern.

**UUIDv7** offers three methods (RFC 9562, Section 6.2):

1. **Fixed-length counter** in `rand_a` or the leading bits of `rand_b`
2. **Monotonic random**: treat the random bits as a counter, increment on each generation
3. **Sub-millisecond precision**: use up to 12 bits of `rand_a` for sub-millisecond clock precision

The approach is left to the implementation. PostgreSQL 18's built-in `uuidv7()` uses method 3, storing sub-millisecond
precision in `rand_a` to guarantee monotonicity within a single backend connection.

## Standardization

**UUIDv7** is defined in RFC 9562, published May 2024 by the IETF. It supersedes RFC 4122 and carries the weight of a
formal internet standard. The version and variant bits make it self-describing: any system that understands UUIDs can
parse a UUIDv7, detect its version, and extract the timestamp.

**ULID** is a community specification hosted on GitHub ([ulid/spec](https://github.com/ulid/spec)). It has broad
adoption and multiple implementations across languages but is not an IETF or ISO standard. There is no version/variant
metadata in the format itself.

## Ecosystem Support

UUIDv7 benefits from the UUID ecosystem. Every language, database, and framework already has UUID support. The `uuid`
column type in PostgreSQL, MySQL's `BINARY(16)`, and ORMs across every language all handle UUIDs natively. PostgreSQL 18
adds a built-in `uuidv7()` function. For earlier versions, the `pg_uuidv7` extension fills the gap.

ULID requires dedicated libraries. Most languages have mature ULID implementations, but you'll need to add a dependency
rather than relying on standard library support. Database storage typically means storing ULIDs as `CHAR(26)`,
`BINARY(16)`, or converting to a UUID-compatible binary representation.

## Comparison

| | ULID | UUIDv7 |
|---|---|---|
| **Size** | 128 bits | 128 bits |
| **String length** | 26 chars | 36 chars |
| **Encoding** | Crockford Base32 | Hex with dashes |
| **Timestamp** | 48-bit ms | 48-bit ms |
| **Random bits** | 80 | 74 (6 used by ver/var) |
| **Standardized** | Community spec | RFC 9562 |
| **UUID-compatible** | No | Yes |
| **Case sensitive** | No | No |
| **URL safe** | Yes | Needs encoding for dashes |
| **Native DB support** | Limited | PostgreSQL 18+, growing |

## Which One Should You Use?

**Use UUIDv7** if you're working in an ecosystem that already uses UUIDs, need database-native support, or want the
backing of a formal standard. In most cases this is the right default. It slots into existing UUID columns, works with
existing UUID libraries, and will only gain more native support over time.

**Use ULID** if you need shorter, more human-readable identifiers, are already using ULIDs in your system, or are
working in a context where the 10-character savings matters (URLs, logs, user-facing IDs). The format is also a
reasonable choice when you want the full 80 bits of randomness per millisecond.

**Either way**, both are a significant improvement over UUIDv4 for database primary keys. The timestamp prefix means
sequential index inserts, better cache locality, and the ability to extract creation time directly from the ID. If
you're still using UUIDv4 as a primary key, switching to either format is worth it.

One thing to keep in mind: both formats embed a creation timestamp, which means they leak timing information. If that's
a concern (security tokens, API keys, session IDs), UUIDv4 remains the right choice for those specific use cases. A
common pattern is UUIDv7 for internal primary keys and UUIDv4 for externally-exposed identifiers.
