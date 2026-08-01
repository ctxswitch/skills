# Drill Flow

Use this reference for an interactive distributed-systems drill.

## Default Loop

1. Restate the target in one sentence.
2. Pick the highest-risk distributed-systems category.
3. Ask one concrete question.
4. Include the answer you suspect or recommend.
5. Wait for the user's answer.
6. Challenge inconsistency, vagueness, or missing mechanisms.
7. Move to the next category only after the current risk is resolved or deliberately deferred.

## Question Shape

Good questions force a mechanism or tradeoff:

```markdown
Question: When the client times out after submitting the mutation, how can it distinguish "not committed" from "committed but response lost"?

My suspected answer: It cannot today; this needs an operation ID plus status lookup or idempotent retry at the mutation boundary.
```

Avoid vague questions:

- "Is this reliable?"
- "What about consistency?"
- "Can this scale?"

Ask instead:

- "Which operation is allowed to read stale data, and for how long?"
- "What is the durability point before the user sees success?"
- "What prevents an expired lock holder from still writing?"

## Escalation Pattern

When the answer exposes a correctness gap:

```markdown
Finding pressure: Critical|High|Medium|Low
Failure mode: ...
Question: ...
My recommended answer: ...
```

Use `Critical` for invariant violations, acknowledged data loss, split-brain writes, unauthorized access, or duplicated irreversible side effects.

Use `High` for persistent divergence, blocked recovery, unsafe failover, broken ordering in critical workflows, or unknowable operation outcomes.

Use `Medium` for stale reads, delayed convergence, unclear degraded mode, missing backpressure, or manual repair risks.

Use `Low` for documentation, test, or telemetry gaps that increase risk but do not directly violate a known invariant.

## Stopping Conditions

Stop the drill when one of these is true:

- The user asks to pause.
- The next step is code or document inspection.
- A missing decision blocks further useful questioning.
- The design has enough resolved decisions to produce a plan, findings list, or ADR.

Close with the smallest useful synthesis:

```markdown
Current weak point: ...
Resolved so far: ...
Next question when we continue: ...
```
