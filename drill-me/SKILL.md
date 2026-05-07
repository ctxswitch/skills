---
name: drill-me
description: "Relentlessly interview and stress-test a distributed-systems plan against the project's existing domain language, code, CONTEXT.md files, ADRs, and distributed-systems correctness concerns. Use when the user asks to be drilled, challenged, interrogated, or pressure-tested on a system design, incident theory, migration, architecture decision, or implementation approach involving services, queues, RPC, replication, caches, consistency, clocks, leader election, locks, retries, failover, recovery, security boundaries, observability, or operational correctness."
---

# Drill Me

Use this skill to interrogate a distributed-systems idea until its guarantees, invariants, failure modes, and operational behavior are precise. Ask one question at a time and wait for the user's answer unless they explicitly ask for a batch.

## Core Behavior

1. Identify the system shape: clients, services, stores, queues, caches, replicas, regions, control planes, and trust boundaries.
2. Extract the claimed guarantees for each critical workflow.
3. Challenge vague terms like "consistent," "reliable," "available," "eventual," "real time," "leader," "lock," "source of truth," and "exactly once."
4. Ask for the mechanism behind each guarantee: quorum, transaction, idempotency key, outbox, fencing token, lease, consensus, reconciliation, retry policy, or operator process.
5. Drill normal distributed failure cases: timeout ambiguity, duplicate delivery, stale reads, partitions, failover, replay, clock skew, split brain, and partial rollout.
6. Include your suspected answer or recommended direction with every question.
7. Inspect code/docs when the answer is discoverable locally instead of asking.
8. Capture resolved domain terms, invariants, and durable architecture decisions when useful.

## Session Flow

Start with a short frame:

```markdown
I am going to drill this as a distributed system. First question:

Question: ...

My suspected answer: ...
```

Then continue one branch at a time. Do not dump a full checklist unless the user asks for one.

Use severity when a gap appears:

```markdown
Finding pressure: High
Why it matters: ...
Question: ...
My recommended answer: ...
```

## Loading Rule

- Read `references/drill-flow.md` when running an interactive drill.
- Read `references/distributed-lenses.md` when choosing which distributed-systems categories to probe.
- Read `references/question-bank.md` when the user wants a batch, mock interview, or broad readiness drill.
- Read `references/capture-rules.md` before updating `CONTEXT.md`, proposing an ADR, or recording resolved terminology.
- For deep technical review, load the relevant `distributed-systems-planner` reference file instead of copying broad context into the response.

## Reference Map

- `references/drill-flow.md`: how to run the Socratic loop.
- `references/distributed-lenses.md`: distributed-systems review categories and trigger signals.
- `references/question-bank.md`: focused question prompts by category.
- `references/capture-rules.md`: when and how to capture terms, invariants, and ADR-worthy decisions.
