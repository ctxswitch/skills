---
name: drill-me
description: "Stress-test a distributed-systems plan against the project's existing domain language, code, CONTEXT.md files, ADRs, and distributed-systems correctness concerns. Use when the user asks to be drilled, challenged, interrogated, or pressure-tested on a system design, incident theory, migration, architecture decision, or implementation approach involving services, queues, RPC, replication, caches, consistency, clocks, leader election, locks, retries, failover, recovery, security boundaries, observability, or operational correctness."
---

# Drill Me

Use this skill to press on unresolved distributed-systems decisions until the idea's guarantees, invariants, failure modes, and operational behavior are precise. Ask one question at a time and wait for the user's answer unless they explicitly ask for a batch.

Do not ask a question if the answer is already stated, directly implied by prior answers, or discoverable from local code/docs. If the answer is discoverable, inspect first and ask only to resolve a contradiction or missing decision.

Continue while the next question exposes a real unresolved decision, contradiction, risk, or implementation consequence. When the next question would only restate known tradeoffs or ask for preference without consequence, summarize what is resolved and identify the next concrete action.

## Core Behavior

1. Identify the system shape: clients, services, stores, queues, caches, replicas, regions, control planes, and trust boundaries.
2. Extract the claimed guarantees for each critical workflow.
3. Challenge vague terms like "consistent," "reliable," "available," "eventual," "real time," "leader," "lock," "source of truth," and "exactly once" only when the ambiguity could lead to different mechanisms, correctness guarantees, ownership, operational behavior, tests, or documentation.
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
