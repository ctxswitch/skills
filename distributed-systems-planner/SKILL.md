---
name: distributed-systems-planner
description: Plan, review, and diagnose distributed systems projects and designs. Use when the user asks to design or critique systems involving services, replicas, queues, RPC, clusters, caches, naming/discovery, clocks, leader election, distributed locks, consistency, replication, fault tolerance, recovery, security boundaries, observability, multi-region architecture, or correctness/completeness analysis of distributed behavior.
---

# Distributed Systems Planner

Use this skill to produce concrete plans, design reviews, and failure/correctness analyses for distributed systems. Keep the main response grounded in the user's system and load reference files only for the details needed.

## Workflow

1. Identify the system shape: components, nodes, clients, data stores, queues, networks, regions, control planes, and trust boundaries.
2. Name the guarantees the user needs: latency, availability, consistency, durability, ordering, isolation, recovery, security, and operability.
3. Separate functional requirements from distributed-systems assumptions. Explicitly call out unstated assumptions.
4. Choose the smallest relevant review frame. Load one task reference first, then add only the domain references needed:
   - Planning a new project: read `references/planning.md`.
   - Reviewing a design or codebase: read `references/review.md`.
   - Debugging or diagnosing issues: read `references/failure-analysis.md`.
   - Checking RPC, queues, streams, gossip, naming, discovery, or service boundaries: read `references/communication-naming.md`.
   - Checking consistency/replication behavior: read `references/consistency-replication.md`.
   - Checking clocks, ordering, locks, elections, or coordination: read `references/coordination.md`.
   - Checking fault tolerance, recovery, commit, or retries: read `references/fault-tolerance.md`.
   - Checking security/trust boundaries: read `references/security.md`.
   - Checking readiness, rollout, testing, observability, or operational maturity: read `references/operations-testing.md`.
   - Needing the concept map: read `references/concepts.md`.
5. Produce the answer as one of:
   - Architecture plan with decisions, tradeoffs, assumptions, and open questions.
   - Review findings ordered by severity, with concrete failure modes and fixes.
   - Correctness checklist with invariants, guarantees, and verification strategy.
   - Diagnostic hypothesis list with evidence to collect and next tests.

## Required Stance

- Prefer named guarantees over vague labels. Say `linearizable`, `sequential`, `causal`, `read-your-writes`, `at-least-once`, `at-most-once`, `durable after quorum ack`, etc.
- Treat retries, timeouts, duplicates, stale reads, partitions, failover, and recovery as normal cases.
- Identify the operation's durability point, visibility point, authorization point, and idempotency key when reviewing critical workflows.
- Flag mismatches between product expectations and technical guarantees.
- Be explicit about impossibility boundaries: global invariants require coordination or reduced availability under partition.
- Recommend tests and observability that exercise histories, failures, and recovery, not only happy-path state.

## Loading Rule

- For broad requests, read `references/concepts.md` plus the task reference.
- For concrete planning/review/diagnosis, skip `concepts.md` unless terminology is unclear.
- Prefer the most specific domain file over multiple broad files.
- If a design crosses several domains, read references incrementally and summarize assumptions before continuing.

## Output Patterns

For planning:

```markdown
## Proposed Architecture
## Guarantees
## Critical Workflows
## Failure Modes
## Data and Consistency
## Operations and Observability
## Open Questions
```

For review:

```markdown
## Findings
- Severity: ...
  Evidence: ...
  Failure mode: ...
  Fix: ...

## Assumptions
## Verification Gaps
```

For diagnosis:

```markdown
## Most Likely Causes
## Evidence to Collect
## Experiments
## Immediate Mitigations
## Durable Fixes
```

## Reference Map

- `references/concepts.md`: condensed Tanenbaum concept map and review lens.
- `references/planning.md`: planning procedure and architecture decision prompts.
- `references/review.md`: design/code review checklist and severity rubric.
- `references/failure-analysis.md`: issue diagnosis by failure class.
- `references/communication-naming.md`: RPC, queues, streams, multicast/gossip, naming, discovery, API boundaries.
- `references/consistency-replication.md`: replication, caches, consistency models, quorum, client-centric guarantees.
- `references/coordination.md`: clocks, logical time, locks, election, ordering.
- `references/fault-tolerance.md`: failure models, retries, reliable communication, groups, commit, recovery.
- `references/security.md`: distributed security, trust boundaries, authn/authz, secure channels.
- `references/operations-testing.md`: observability, test strategy, rollout, readiness, and operational review.
