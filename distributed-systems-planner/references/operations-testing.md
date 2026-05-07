# Operations, Observability, Testing, and Rollout

Use this for readiness reviews, operational maturity checks, test planning, observability, rollout safety, migration plans, and production-debuggability.

## Table of Contents

- Observability
- Testing strategy
- Failure injection
- Readiness review
- Rollout and migration
- Runbooks
- Operational anti-patterns
- Review checklist

## Observability

Best practices:

- Propagate trace ID, request ID, operation ID, session ID, and leader epoch where relevant.
- Record which replica/cache served each read and which authority accepted each write.
- Emit structured state-transition logs for critical workflows.
- Make unknown outcomes explicit in logs and API status.
- Track time-based lag, not only counts or offsets.

Core signals:

- request latency by dependency and percentile
- retry count and retry reason
- timeout count by callsite
- dedupe hits/misses
- queue depth and oldest message age
- consumer lag by time
- replication lag
- cache stale-hit or validation-failure rate
- leader changes and election duration
- clock skew
- quorum failures
- conflict/divergence rate
- checkpoint/replay/recovery progress
- authorization denials by reason and policy version

Anti-patterns:

- Logs without operation IDs.
- Metrics that show throughput but not correctness lag.
- Alerting on queue depth but not oldest message age.
- No way to distinguish "not executed" from "unknown outcome."

## Testing Strategy

Best practices:

- Test histories, not only final state.
- Test invariants under concurrency and failure.
- Include stale reads, duplicate delivery, lost replies, failover, and recovery in normal test suites.
- Use property tests for merge/idempotency behavior.
- Use model checking or state-machine tests for compact protocols and invariants when feasible.
- Test mixed-version behavior before rollout.

Minimum distributed test set:

- retry after timeout
- duplicate mutation
- response lost after commit
- out-of-order message delivery
- stale read from replica/cache
- partition old leader from quorum
- promote lagging replica attempt
- clock skew or process pause when leases/timestamps matter
- crash and recovery at each critical phase
- permission revocation propagation

## Failure Injection

Inject:

- latency
- packet/message loss
- duplicate delivery
- reordering
- dependency timeout
- process crash
- process pause
- disk full or fsync failure
- clock skew/time jump
- network partition
- partial region outage
- stale service discovery

Best practices:

- Start in deterministic integration tests, then controlled staging, then scoped production drills.
- Define expected behavior before injecting.
- Verify data correctness after the drill, not just service recovery.

## Readiness Review

Require answers for:

- What are critical workflows and invariants?
- What is the commit point for each workflow?
- What is retried automatically?
- What can be duplicated?
- What can be stale?
- What is the recovery source of truth?
- What dashboards prove health and correctness?
- What alerts fire before user-visible failure?
- What manual runbooks exist?
- What is the rollback plan?

## Rollout and Migration

Best practices:

- Separate deploy from activation.
- Use canaries and progressive rollout.
- Use expand/migrate/contract for schema and protocol changes.
- Keep rollback compatible with data written by the new version.
- Roll out readers before writers for new fields.
- Backfill with idempotent, restartable jobs.
- Emit migration progress and error metrics.

Anti-patterns:

- One-shot global migration.
- New writers before old readers tolerate new format.
- Rollback that cannot read newly written data.
- Feature flags that alter consistency behavior without telemetry.

## Runbooks

Runbooks should include:

- symptom
- blast radius check
- dashboards/log queries
- immediate mitigation
- safety checks before mitigation
- data correctness checks
- recovery/replay/reconciliation steps
- escalation owner
- rollback criteria

Best practices:

- Include "do not do" actions for risky manual fixes.
- Make reconciliation dry-runnable.
- Record operator actions in audit logs.

## Operational Anti-Patterns

- Only testing component liveness, not semantic correctness.
- Manual repair scripts with no idempotency.
- Backfill jobs that bypass authorization or validation.
- Alert fatigue from symptoms without root-cause signals.
- No way to inspect operation status after timeout.
- No owner for cross-service invariants.

## Review Checklist

- Telemetry can reconstruct a critical operation end to end.
- Dashboards expose lag, retries, dedupe, conflicts, elections, and recovery.
- Tests cover failure histories.
- Rollout supports mixed versions.
- Rollback is compatible with new data.
- Runbooks include correctness checks.
- Reconciliation jobs are idempotent and observable.
