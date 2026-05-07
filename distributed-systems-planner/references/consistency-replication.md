# Consistency and Replication

Use this for replicated data, caches, read replicas, multi-region writes, quorum protocols, conflict resolution, and client-visible anomalies.

## Table of Contents

- Replication reasons
- Replication best practices
- Data-centric models
- Client-centric models
- Replica management
- Consistency protocols
- Conflict analysis
- Correctness prompts
- Test cases

## Replication Reasons

- Reliability: survive component failure.
- Performance: serve reads/writes closer to clients.
- Scalability: spread load.
- Offline/local operation: keep working without central connectivity.

Always ask which reason applies; it determines acceptable consistency costs.

## Replication Best Practices

- Replicate only after defining the source of truth and write authority.
- Name the consistency model for each read/write path.
- Keep read replicas and caches inside the documented consistency contract.
- Prefer single-writer or partition-owner designs when invariants are hard to merge.
- Use quorum settings with explicit read/write overlap when freshness matters.
- Make conflict resolution deterministic, observable, and domain-aware.
- Preserve client-centric guarantees for workflows where users naturally expect continuity.
- Treat deletion, resurrection, and tombstone garbage collection as first-class design topics.
- Expose replication lag and conflict rates as operational signals.

Anti-patterns:

- Adding replicas for performance without revisiting semantics.
- Serving critical reads from stale replicas.
- Multi-primary writes with last-writer-wins for user-intent data.
- Using physical timestamps for conflict resolution without skew control.
- Assuming cache invalidation is reliable without repair or validation.

## Data-Centric Models

Linearizability:

- Operations appear atomic and respect real-time order.
- Good for locks, allocation, uniqueness, balances.
- Requires coordination for replicated mutable data.

Sequential consistency:

- One global order exists and respects each process's order.
- Does not need to match wall-clock real time.

Causal consistency:

- Causally related operations are observed in order.
- Useful for conversations, permissions workflows, collaborative state.

FIFO consistency:

- Writes from each process are observed in order.

Weak/release/entry consistency:

- Synchronization operations define when data must become consistent.

## Client-Centric Models

Monotonic reads:

- A client does not go backward in observed state.

Monotonic writes:

- A client's writes are applied in issue order.

Read-your-writes:

- A client sees its own prior writes.

Writes-follow-reads:

- A write is ordered after reads that influenced it.

Review prompts:

- What is a session?
- Does the client carry session/version metadata?
- Are guarantees preserved across replicas, failover, and regions?

Best practices:

- Define a session boundary: login, device, token, request chain, or explicit session object.
- Carry session/version metadata when clients can move between replicas.
- Provide read-your-writes for workflows that immediately display user changes.
- Use monotonic reads for feeds, dashboards, and user-facing progress states.

## Replica Management

Replica types:

- Permanent replicas: always part of service.
- Server-initiated replicas: created for load/geography.
- Client-initiated replicas/caches: created near clients.

Distribution choices:

- Push updates.
- Pull updates.
- Push invalidations.
- Pull validation on use.

Review prompts:

- Where are replicas placed and why?
- What content is replicated?
- How are replicas added/removed?
- How does new replica catch up?
- How are deletes/tombstones handled?

## Consistency Protocols

Primary-based:

- All writes pass through a primary.
- Simple ordering.
- Risks: primary bottleneck, failover, stale backups.

Replicated-write:

- Writes sent to multiple replicas.
- Risks: ordering, conflicts, divergent acceptance.

Quorum:

- Choose read quorum NR and write quorum NW over N replicas.
- Need NR + NW > N to make reads overlap writes.
- Need NW > N/2 to prevent disjoint concurrent write quorums.

Read-one/write-all:

- Fast reads.
- Writes require all replicas and are fragile under failure.

Cache coherence:

- Invalidate on write.
- Update on write.
- Validate on access.
- Validate on commit.
- Write-through or write-back.

Protocol best practices:

- Primary-based: require clear failover, catch-up, and stale-primary rejection.
- Replicated-write: require deterministic operation ordering or commutative/idempotent operations.
- Quorum: verify `NR + NW > N` for read/write overlap and `NW > N/2` to prevent disjoint writes.
- Cache coherence: choose invalidate, update, validate-on-use, or validate-on-commit based on data criticality.
- Write-back caches: require flush, conflict, and crash semantics.

## Conflict Analysis

For each data type:

- Are operations commutative?
- Are operations idempotent?
- Are operations order-sensitive?
- What conflicts can happen?
- Is merge deterministic?
- Is merge intent-preserving?
- Are deletes represented with tombstones?
- Can conflict resolution violate domain invariants?

Red flags:

- Last-writer-wins for important user intent.
- Physical timestamps used without skew bounds.
- Deletes without tombstones.
- Multi-primary writes without conflict workflow.
- Cache invalidations over unreliable delivery.

## Correctness Prompts

- Which operation orders must all clients agree on?
- Which stale reads are acceptable?
- Which reads must be linearizable?
- Which workflows require read-your-writes?
- Which invariants require coordination?
- Does the chosen protocol actually enforce the stated model under failover?

## Test Cases

- read after write from different replica
- concurrent writes to same key
- concurrent delete and update
- primary failover during write
- write accepted then response lost
- cache invalidation lost
- read quorum during replica lag
- client moves regions mid-session
- tombstone garbage collection before delayed update
