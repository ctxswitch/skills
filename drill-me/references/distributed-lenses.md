# Distributed Lenses

Use this to choose the next drill angle. Pick the lens that threatens correctness first, then availability, then operability.

## System Shape

Probe when the plan mentions services, workers, queues, caches, databases, replicas, regions, external APIs, or control planes.

Ask for:

- authoritative owners of mutable data
- synchronous request path
- async completion path
- stateful components
- backpressure boundaries
- trust boundaries

Red flags:

- hidden synchronous dependencies
- shared database as service integration
- cyclic service calls
- control-plane outage corrupts data-plane behavior

## Guarantees and Invariants

Probe whenever the user says "must," "always," "never," "exactly once," "consistent," "source of truth," or "highly available."

Ask for:

- invariant statement
- scope: local, shard, region, or global
- operation that can violate it
- enforcement mechanism
- behavior under partition
- repair or compensation

Red flags:

- global invariant plus high availability under partition
- "exactly once" without idempotency and durable dedupe
- "strong consistency" while serving cache or follower reads

## Communication

Probe for RPC, queues, streams, events, pub/sub, webhooks, and service APIs.

Ask for:

- deadline and timeout semantics
- retry budget, backoff, and jitter
- idempotency key
- dedupe storage
- ordering scope
- poison message handling
- status lookup after ambiguous timeout

Red flags:

- retrying mutating calls without operation IDs
- treating timeout as failure
- unbounded retries
- event emitted separately from state change without outbox or transaction

## Replication and Caching

Probe for replicas, read models, materialized views, caches, CDNs, search indexes, and multi-region state.

Ask for:

- consistency model per read path
- write owner
- replication topology
- conflict strategy
- cache invalidation/update path
- read-your-writes expectations
- tombstone and delete behavior

Red flags:

- user-facing workflow depends on fresh data from eventually consistent read path
- multi-primary writes without conflict model
- deletes without tombstones or versioning

## Coordination

Probe for leader election, leases, distributed locks, cron ownership, schedulers, and single-writer assumptions.

Ask for:

- term, epoch, or fencing token
- protected resource enforcement
- lease clock assumptions
- leader catch-up before serving
- split-brain test
- stale holder behavior

Red flags:

- lock protects only cooperation, not the actual write
- lease without fencing
- leader writes accepted without epoch check

## Recovery and Side Effects

Probe for crashes, replay, workflow engines, sagas, commit protocols, payments, emails, webhooks, and external APIs.

Ask for:

- durable commit point
- visibility point
- replay behavior
- side-effect ledger or outbox
- compensation path
- recovery order
- backup restore invariant checks

Red flags:

- acknowledged success before durable state
- replay can duplicate external side effect
- recovery process restores bytes but not application invariants

## Security Boundaries

Probe for service-to-service calls, async workers, cached permissions, tenants, admin operations, and external integrations.

Ask for:

- authentication point
- authorization point
- caller authority propagation
- cached auth TTL/version/revocation
- key rotation
- tenant isolation

Red flags:

- worker runs with broad authority detached from original caller
- cached authorization has no revocation story
- internal network treated as trust boundary

## Operations and Testing

Probe for rollout, observability, debugging, runbooks, migrations, and SLOs.

Ask for:

- golden signals and domain correctness metrics
- trace/correlation IDs across async boundaries
- chaos/failure tests
- mixed-version compatibility
- rollback plan
- repair tooling

Red flags:

- tests cover only happy-path state
- no telemetry for duplicates, retries, lag, divergence, or repair
- migration assumes all components upgrade simultaneously
