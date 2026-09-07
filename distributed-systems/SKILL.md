---
name: distributed-systems
description: "Plan or review a distributed-system design, and reason about failures that span nodes. Use when the question is about behaviour under partition, retry, duplication, replication, coordination, failover, or recovery — not for ordinary service code that happens to make network calls, and not for a single reproducible failure whose cause is unknown (diagnose)."
---

# Distributed Systems

Use this skill to produce concrete plans, design reviews, and failure/correctness analyses. Keep the main response grounded in the user's system and load reference files only for the details needed.

## Right-size first (read before proposing anything)

The default failure mode of this skill is over-engineering: adding machinery for rare, low-impact, or purely theoretical failures at the cost of real complexity. Guard against the bias:

- **Establish scale and blast radius before proposing any mechanism.** Node/region count, request volume, data criticality, how bad a failure actually is, and the team's operational maturity. A three-node internal tool and a multi-region payments ledger earn different rigor. If these are unknown, ask or state an explicit assumption — never silently default to the heavyweight design.
- **The simplest design that meets the *named* guarantees wins.** Do not build to a guarantee the user did not ask for. When a missing one would break correctness, completeness, or scale, name it and ask for direction.
- **Every mechanism must earn its place.** Justify each one by either (a) a stated requirement or (b) a failure that is realistic at *this* system's scale and criticality. If it is neither, it does not go in the design.
- **New machinery is itself a new failure domain.** A lock service, consensus group, extra hop, or coordination protocol can fail too. Weigh that cost against the risk it removes.
- **Default to the boring option** unless scale or criticality demands more: a database constraint over a distributed lock, a retry over a saga, one writer over consensus, idempotent redo over exactly-once, a documented runbook over automated failover.
- **Sort every risk into must-handle / watch / accept.** Build only for must-handle. For *watch*, add an alert and handle it if it ever fires. For *accept*, write one sentence and move on. "Rare and recoverable" belongs in watch or accept, not in the architecture.

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
- Treat retries, timeouts, duplicates, stale reads, partitions, failover, and recovery as *possible*, then rank them by likelihood × impact at this system's scale. Design for the material ones; name the rest as watched or accepted risks.
- Recommend the least mechanism that meets the requirement. When you propose coordination, consensus, or a new component, state plainly what breaks without it and why a simpler option (constraint, single writer, idempotency, retry) is insufficient here. If you can't, drop it.
- Identify the operation's durability point, visibility point, authorization point, and idempotency key when reviewing critical workflows.
- Flag mismatches between product expectations and technical guarantees — in both directions. Under-engineering (a guarantee the design can't deliver) and over-engineering (rigor the requirement never asked for) are both defects worth calling out.
- Be explicit about impossibility boundaries: global invariants require coordination or reduced availability under partition. State the cost.
- Recommend tests and observability that exercise histories, failures, and recovery, not only happy-path state — scaled to the risks you chose to handle, not every risk you can name.

## Loading Rule

- For broad requests, read `references/concepts.md` plus the task reference.
- For concrete planning/review/diagnosis, skip `concepts.md` unless terminology is unclear.
- Prefer the most specific domain file over multiple broad files.
- If a design crosses several domains, read references incrementally and summarize assumptions before continuing.

## Output Patterns

These list what to cover when it exists. They are not blanks to complete — a heading with nothing behind it is deleted, and a design that fills every heading is more likely padded than thorough. No restating the requirement back, no narrating how the design was reached, no defending a choice nobody contested.

For planning (`Failure Modes` is ranked by likelihood × impact and lists only the ones the design actually handles; everything rare-and-recoverable goes under `Accepted / Deferred Risks` with a one-line reason, not into the architecture):

```markdown
## Proposed Architecture
## Guarantees
## Critical Workflows
## Failure Modes            (material, ranked, each with the mechanism that handles it)
## Data and Consistency
## Operations and Observability
## Accepted / Deferred Risks  (known but not designed for — why it's acceptable / what would change that)
## Open Questions
```

For review (prune findings by materiality before reporting; a theoretically-possible failure that is rare, low-impact, and cheaply recovered is a note, not a finding):

```markdown
## Findings                 (ranked by severity; each a real, material failure at this system's scale)
- Severity: ...
  Evidence: ...
  Failure mode: ...
  Fix: ...

## Accepted / Low-Priority  (possible but not worth mechanism now — with the reason)
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

Domain:

- `references/concepts.md`: condensed Tanenbaum concept map and review lens.
- `references/communication-naming.md`: RPC, queues, streams, multicast/gossip, naming, discovery, API boundaries.
- `references/consistency-replication.md`: replication, caches, consistency models, quorum, client-centric guarantees.
- `references/coordination.md`: clocks, logical time, locks, election, ordering.
- `references/fault-tolerance.md`: failure models, retries, reliable communication, groups, commit, recovery.
- `references/security.md`: distributed security, trust boundaries, authn/authz, secure channels.
- `references/operations-testing.md`: observability, test strategy, rollout, readiness, operational review, and the canonical failure-test set.

Task:

- `references/planning.md`: planning procedure and architecture decision prompts.
- `references/review.md`: design/code review checklist and severity rubric.
- `references/failure-analysis.md`: issue diagnosis by failure class.
