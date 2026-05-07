# Distributed Failure Analysis

Use this to diagnose incidents, flaky behavior, data anomalies, or unclear distributed bugs.

## Table of Contents

- First classify the symptom
- Diagnostic questions
- Evidence to collect
- Common incident patterns
- Diagnostic best practices by category
- Hypothesis output pattern

## First Classify the Symptom

Communication:

- timeout
- connection failure
- duplicate message
- lost message
- out-of-order message
- queue backlog
- poison message

Ordering:

- stale read
- causality violation
- inconsistent ordering between replicas
- reply before request-like dependency

Naming/discovery:

- stale address
- wrong endpoint
- split service registration
- reused identity

Timing:

- clock skew
- lease expiry
- time jump
- delayed message
- scheduler/GC pause

Replication/consistency:

- divergent replicas
- lost update
- conflict resolution surprise
- cache coherence failure

Coordination:

- split brain
- lock safety failure
- failed election
- coordinator unavailable

Recovery:

- replay duplicate
- missing log
- stale checkpoint
- partial transaction
- blocked commit

Security:

- stale authorization
- missing authentication
- key rotation failure
- policy propagation lag

## Diagnostic Questions

- What operation did the caller believe happened?
- What did each component observe?
- Was there a timeout? If yes, did the operation later commit?
- Was there a retry? If yes, did it reuse a stable idempotency key?
- Which replica served each read?
- Which node accepted each write?
- Was there a leader change?
- Were clocks skewed or adjusted?
- Were messages delayed, duplicated, or reordered?
- Did recovery replay work?
- Did authorization data change during the workflow?

## Evidence to Collect

- request IDs and trace IDs
- idempotency keys
- session/client IDs
- leader term/epoch/fencing token
- replica ID for reads and writes
- queue offsets and ack records
- operation log entries
- commit timestamps and logical clocks
- cache version/age
- clock skew metrics
- retry count and timeout reason
- failover/election logs
- membership views
- authorization policy version
- recovery/checkpoint/log replay records

## Common Incident Patterns

Lost response after commit:

- Server commits, response is lost, client retries.
- Risk: duplicate mutation unless idempotent.
- Check: operation ID present in durable mutation table.

Stale read after write:

- Write accepted by primary, read served from lagging replica/cache.
- Risk: user sees old state or makes wrong next decision.
- Check: read routing, session token, replica lag, cache invalidation.

Split brain:

- Partition or pause causes multiple leaders to accept writes.
- Risk: conflicting authority and data corruption.
- Check: epochs, fencing, quorum, lease assumptions, client routing.

Queue reordering:

- Consumers process related messages out of order.
- Risk: invalid state transition.
- Check: partition key, consumer concurrency, sequence checks.

Retry storm:

- Timeouts trigger retries that overload the slow dependency further.
- Risk: cascading failure.
- Check: retry budget, jitter, circuit breaker, backpressure.

Stale auth:

- Permission revoked but cached decision remains active.
- Risk: unauthorized access.
- Check: TTL, policy versioning, fail-open/fail-closed behavior.

Recovery replay duplicate:

- Process restarts and replays messages or outbox records.
- Risk: duplicate external side effect.
- Check: external idempotency, side-effect ledger, exactly-once claims.

## Diagnostic Best Practices by Category

Communication:

- Preserve request ID, operation ID, retry count, deadline, and final transport/application status.
- Distinguish "not executed" from "unknown" from "executed but response lost."
- Inspect retry amplification across layers before blaming a single service.

Messaging:

- Inspect queue age, delivery count, ack timing, consumer group/partition, and dead-letter records.
- Reconstruct whether state commit happened before or after message ack/publish.
- Check for out-of-order processing where the topic only guarantees per-partition order.

Replication and caching:

- Identify the exact replica/cache that served each read.
- Compare write commit time, replication lag, cache age, and invalidation delivery.
- Check whether failover promoted a stale replica.

Coordination:

- Collect leader epoch/term, membership view, lease token, and fencing token for every contested write.
- Treat pauses and partitions as separate from process death.
- Check for stale leaders that retained client connectivity after losing quorum.

Recovery:

- Determine whether the node recovered from checkpoint, log replay, peer sync, or manual repair.
- Check whether replay crossed an external side-effect boundary.
- Compare restored local state against cluster/global invariants.

Security:

- Collect auth policy version, credential identity, token issue/expiry time, and cache source.
- Check every read path, not only the write path or edge gateway.

## Hypothesis Output Pattern

```markdown
## Hypotheses
1. ...
   Evidence for:
   Evidence against:
   How to test:

## Data to Pull
## Immediate Mitigation
## Durable Fix
```
