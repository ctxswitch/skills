# Planning Distributed Systems

Use this for new designs, architecture proposals, migrations, or project plans.

## Table of Contents

- Planning procedure
- Architecture prompts
- Guarantee prompts
- Invariant classification
- Communication choices
- Data and replication choices
- Coordination choices
- Recovery planning
- Observability plan
- Planning output skeleton

## Planning Procedure

1. State the product goal and critical workflows.
2. Draw the execution model in text: clients, services, data stores, queues, caches, regions, control planes, external dependencies.
3. Define guarantees per workflow, not globally.
4. Identify invariants and classify their scope.
5. Choose communication patterns and failure semantics.
6. Choose data ownership, replication, and consistency.
7. Choose coordination mechanisms only where needed.
8. Define recovery and operational behavior.
9. Define security boundaries.
10. Define tests and observability.

## Architecture Prompts

- Which components are stateful?
- Which components can be horizontally scaled?
- Which components are authoritative for which data?
- What is synchronous on the request path?
- What is asynchronous and eventually completed?
- Which operations cross regions or administrative domains?
- Where can backpressure be applied?
- What degrades first under overload?

Best practices:

- Keep data ownership clear and narrow.
- Keep synchronous request paths short.
- Separate control plane and data plane when they fail differently.
- Put backpressure at every boundary that can overload another component.
- Version APIs, events, and durable records from the first release.

Anti-patterns:

- Shared database as cross-service integration layer.
- Hidden synchronous calls inside helpers, SDKs, or middleware.
- Cyclic service dependencies.
- Centralized metadata service with no degraded mode.
- Health checks that prove only process liveness.

## Guarantee Prompts

For each critical workflow, specify:

- latency target and tail percentile
- availability target
- consistency model
- durability point
- retry semantics
- ordering needs
- isolation or concurrency control
- authorization requirements
- recovery objective
- auditability

Avoid global claims like "strongly consistent" or "highly available." Tie claims to operations.

## Invariant Classification

Classify each invariant:

- Local: enforce in one process or one row/document.
- Shard-local: enforce within a partition key.
- Regional: enforce within one region.
- Global: requires cross-shard/region coordination or accepts temporary violation.

Typical global invariants:

- uniqueness
- inventory cannot go negative
- account balance cannot go negative
- exactly-once external side effect
- permission revocation before access
- single active leader

Planning rule:

- If a global invariant must always hold, put coordination on the write path or reduce availability under partition.
- If availability wins, design conflict handling, compensation, or user-visible pending states.

## Communication Choices

Use RPC for:

- request/response operations needing immediate result
- low fan-out
- bounded latency dependencies

Use queues/events for:

- decoupling
- buffering
- fan-out
- retryable workflows
- eventual completion

Use streams for:

- time-dependent data
- telemetry
- ordered event flows
- freshness-sensitive processing

Plan explicitly:

- timeout
- retry
- idempotency
- deduplication
- ordering
- durability
- backpressure
- poison message handling

Best practices:

- Use deadlines instead of unbounded timeouts.
- Use retry budgets, exponential backoff, and jitter.
- Require stable operation IDs for mutating calls.
- Treat timeout as unknown outcome unless a status lookup proves otherwise.
- Make async consumers idempotent by default.

## Data and Replication Choices

Plan:

- source of truth
- replica topology
- read path
- write path
- cache invalidation/update strategy
- conflict model
- client/session guarantees
- failover behavior
- repair/reconciliation

Use primary-based replication when simple ordering matters and primary availability is acceptable.

Use quorum replication when tunable read/write availability and freshness are needed.

Use multi-primary only when conflicts are expected and resolvable.

Use caches only when staleness is acceptable or invalidation is reliable enough for the workflow.

Best practices:

- Assign one write owner for each mutable data domain where possible.
- Make derived state rebuildable from an authoritative source.
- Treat deletes as replicated operations with tombstones or versioning when delayed updates are possible.
- Define read-your-writes behavior for user-facing workflows.
- Avoid multi-primary writes unless conflicts are explicitly modeled and acceptable.

## Coordination Choices

Use leader election for coordinating service roles, not for data correctness by itself.

Use distributed locks sparingly. Prefer:

- single-writer partition ownership
- compare-and-swap with fencing tokens
- transactional constraints
- idempotent workflows
- queues with per-key ordering

If using leases, define:

- clock assumptions
- max pause assumptions
- fencing token enforcement
- renewal behavior
- expiry behavior under partition

Best practices:

- Prefer database constraints, partition ownership, compare-and-swap, or consensus logs over ad hoc distributed locks.
- If leases are used, require fencing tokens checked by the protected resource.
- Attach leader epochs or terms to writes that depend on leadership.
- Require new leaders to catch up before serving writes.

## Recovery Planning

Define:

- what state is durable
- where operation logs live
- checkpoint/snapshot strategy
- replay semantics
- external side-effect handling
- recovery order
- split-brain repair
- data reconciliation

Every plan should answer:

- Can an operation commit and then be forgotten?
- Can an operation be replayed twice?
- Can recovery expose stale or unauthorized state?

Best practices:

- Define the durable commit point for every critical operation.
- Log before acknowledging externally visible success.
- Use an outbox or equivalent ledger for external side effects.
- Make replay deterministic and side effects idempotent.
- Test crash points between receive, validate, write, emit, and ack.

## Observability Plan

Track:

- request latency and error class
- retry counts
- duplicate suppression hits
- queue depth and age
- replication lag
- cache hit/stale rate
- leader changes
- election duration
- clock skew
- quorum failures
- divergence/conflict rate
- recovery progress
- authorization denials by reason

## Planning Output Skeleton

```markdown
## Goal
## Components
## Critical Workflows
## Guarantees by Workflow
## Data Ownership and Replication
## Coordination and Ordering
## Failure and Recovery Behavior
## Security Boundaries
## Observability
## Tests
## Open Questions
```
