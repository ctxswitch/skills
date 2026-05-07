# Reviewing Distributed Systems

Use this for architecture reviews, design docs, PRDs, code reviews with distributed behavior, or readiness reviews.

## Table of Contents

- Review method
- Severity rubric
- Claim vs mechanism checks
- Category best practices to check
- Operation review template
- Invariant review template
- Common findings
- Test review
- Review output format

## Review Method

1. Extract claimed guarantees.
2. Identify actual mechanisms.
3. Compare claims to mechanisms.
4. Enumerate failure cases.
5. Check critical invariants.
6. Check retries, timeouts, duplicates, and recovery.
7. Check observability and tests.
8. Report findings by severity.

## Severity Rubric

Critical:

- Can violate a business/security correctness invariant.
- Can lose acknowledged data.
- Can create split-brain authority.
- Can allow unauthorized access.
- Can duplicate irreversible external side effects.

High:

- Can cause prolonged outage or blocked recovery.
- Can create persistent divergence.
- Can break read-your-writes or ordering in a critical workflow.
- Can make operations unknowable after timeout.

Medium:

- Can cause stale reads, delayed convergence, poor failover, or manual repair.
- Can create ambiguous behavior under realistic but non-catastrophic failure.

Low:

- Documentation, observability, or test gaps that increase risk but do not directly violate a known invariant.

## Claim vs Mechanism Checks

For every guarantee claim, ask:

- What mechanism enforces it?
- Is the mechanism on every path?
- Does it survive failover?
- Does it include caches, async workers, and repair jobs?
- Does it include degraded/partitioned operation?

Red flags:

- "Exactly once" without idempotency and durable dedupe.
- "Strong consistency" while serving follower/cache reads.
- "Highly available" plus global invariant without coordination.
- "Leader elected" without fencing.
- "Retry safe" without operation IDs.

## Category Best Practices to Check

Architecture:

- Data ownership is explicit.
- Synchronous dependencies are visible and bounded.
- Backpressure exists at service, queue, and storage boundaries.
- Control plane failure does not silently corrupt data-plane behavior.

Communication:

- Every remote call has a deadline.
- Mutating calls have idempotency keys or are explicitly not retried.
- Timeouts produce unknown outcome unless status lookup exists.
- Retry policies use budgets, backoff, and jitter.

Messaging:

- Consumers are idempotent.
- Ordering scope is documented.
- Producer state changes and emitted events are atomic through outbox, transaction, or equivalent.
- Poison messages cannot block unrelated work indefinitely.

Replication and caching:

- The consistency model is named.
- Read paths include caches and replicas in the guarantee.
- Conflict resolution is deterministic and domain-aware.
- Deletes and tombstone GC are reviewed against delayed updates.

Coordination:

- Locks/leases use fencing where stale holders can act.
- Leader writes include epoch/term checks.
- New leaders prove catch-up before serving.
- Split-brain tests exist.

Recovery:

- Commit points are durable before acknowledgment.
- Replay cannot duplicate irreversible side effects.
- Recovery from each protocol phase is specified.
- Backups restore application invariants, not just bytes.

Security:

- Service-to-service calls are authenticated and authorized.
- Cached authorization has TTL/version/revocation strategy.
- Key rotation supports mixed versions.
- Async workers preserve or intentionally replace caller authority.

## Operation Review Template

For each critical operation:

- Inputs and preconditions.
- Idempotency key and dedupe storage.
- Authorization point.
- Write path.
- Durability point.
- Visibility point.
- Retry behavior.
- Timeout behavior.
- Side effects.
- Recovery behavior.
- Observability.

## Invariant Review Template

For each invariant:

- Statement of invariant.
- Scope: local/shard/region/global.
- Operations that can violate it.
- Coordination mechanism.
- Failure behavior under partition.
- Repair or compensation.
- Tests.

## Common Findings

Timeout ambiguity:

- Client timeout does not mean failure.
- Fix by operation IDs, status lookup, idempotent retry, and explicit state machine.

Duplicate mutation:

- At-least-once delivery calls non-idempotent handler.
- Fix by dedupe key in durable storage at the mutation boundary.

Split brain:

- Two leaders can write concurrently.
- Fix by consensus, quorum lease with fencing, or single-writer partition ownership.

Stale authorization:

- Cached permission allows access after revocation.
- Fix by short TTL, revocation tokens, version checks, or fail-closed boundary.

Replica divergence:

- Multi-primary writes conflict without deterministic merge.
- Fix by single writer, quorum, CRDT/merge semantics, or conflict workflow.

Unsafe lock:

- Distributed lock expires while holder still acts.
- Fix by fencing tokens enforced by the protected resource.

Recovery side effects:

- Replay resends payment/email/webhook.
- Fix by durable outbox, idempotency at receiver, and side-effect ledger.

## Test Review

Expect tests for:

- retry after timeout
- duplicate delivery
- out-of-order delivery
- lost response after commit
- leader failover during write
- stale read from replica/cache
- network partition
- clock skew or pause if leases/timestamps matter
- recovery from checkpoint/log
- rolling upgrade with mixed versions
- permission revocation propagation

## Review Output Format

```markdown
## Findings
- Severity: Critical|High|Medium|Low
  Area: consistency|fault tolerance|security|communication|naming|recovery|ops
  Evidence:
  Failure mode:
  Recommendation:
  Verification:

## Assumptions
## Open Questions
## Missing Tests/Telemetry
```
