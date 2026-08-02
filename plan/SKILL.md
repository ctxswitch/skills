---
name: plan
description: "Research a change against the codebase, write it up as phased work packets, then attack the draft until it survives. Use when a change needs designing before anyone builds it. Writes no code. For product intent use prd; for splitting an approved plan into tickets use issues."
---

# Plan

Produce a plan someone can execute with no memory of the conversation that produced it. Then try to break it.

**Enter the harness's plan mode before reading anything.** In Claude Code call `EnterPlanMode` first; if it is not in the tool list, load it with `ToolSearch`, then call it. Where no plan mode exists, the rules below are the only gate.

The only file this skill writes is the plan document. No source file changes — not a rename, not a formatting pass, not a one-line fix noticed in passing. Something that must change earns a line in the plan, not an edit. If the request turns out to be smaller than the plan describing it, say so and stop.

## Guard against the defaults

The default failure mode is a plan written from what the code is assumed to do, organised the way the code already is, and padded until it looks thorough.

- **Verify specifics before planning around them.** Signatures, callers, config keys, error types, current behaviour, existing tests, pinned versions. A plan built on a remembered call graph is a plan to break something. Read it, or mark the step as unverified so the executor knows to check.
- **Do not manufacture links.** Before writing that one phase blocks another, that two modules are coupled, or that a change contradicts a recorded decision, name the concrete case where it holds. Shared vocabulary is not a dependency. If you cannot name the case, drop the claim.
- **Plan the change, not the codebase.** Adjacent cleanups, opportunistic refactors, tests for untouched code, and rename passes belong under out of scope, not in a phase.
- **Do not plan a spike.** "Investigate X" as a phase means the exploration is not finished. Go and do it now, then plan with the answer in hand.
- **A phase with nothing behind it is deleted, not filled.** Coverage of the change is the bar, not phase count.

## 1. Explore

Read the `.context.md` files from the repo root down to the area being changed — they carry the domain language and the decisions already settled. The `context` skill defines the layout.

Then read the code the change touches, plus its callers and its tests. Explore independent subsystems in parallel where the harness supports it.

Finish exploring before drafting. Resolve ambiguity that would change the plan's shape while still here, using `AskUserQuestion` where the harness has it. Do not ask what the code answers.

## 2. Draft phases

Slice vertically. The default is horizontal — "add the schema", "add the API", "add the UI" — and it produces phases nobody can verify alone. Each phase carries a narrow but complete path through every layer it touches, so it can be committed green.

Each phase is a self-contained work packet:

- **Goal** — the behaviour that exists at the end and did not before.
- **Files** — what gets touched, and what is deliberately left alone.
- **Changes** — modules, interfaces, and data. Not a diff.
- **Exit criterion** — the command that proves it, and the result that counts as passing.
- **Commit** — the message, in the repo's convention.

A phase may depend on an earlier phase, never a later one. Two phases that depend on each other are one phase.

An exit criterion is a test that must pass, a build that must succeed, or a metric that must move in a stated direction. "Verify it works" is not one. **For a performance change the criterion is a number** — run the measurement and record the baseline while writing the plan, not after the change lands. A green test suite is not evidence of a performance win.

## 3. Adversarial passes

Each pass is a separate reading of the plan with one question in hand, answered against the code rather than against the plan's own account of it. Run them as parallel subagents where the harness supports it.

A pass either produces findings with evidence — file, line, the concrete failure — or reports nothing. Do not pad a pass that found nothing, and do not soften one that found something. A pass that only ever adds phases is being run wrong.

- **Scope** (`engineer`, over-engineering) — For every abstraction, layer, configuration knob, and resilience mechanism the plan introduces: name the failure it covers and the path the code takes to reach it. Cut the ones serving a second caller who does not exist yet, and the recovery paths for states no caller can produce.
- **Depth** (`architecture`) — Apply the deletion test to every module the plan adds: if it vanished, does complexity disappear or reappear across callers? Where the net effect is more files, more indirection, and more names to learn, say what the leverage is. Any seam with exactly one implementation is a hypothetical.
- **Evidence** (`engineer`, verify specifics) — Open the file behind every claim the plan makes about code that already exists. Anything that does not hold is corrected or cut; anything that cannot be checked is marked unverified rather than asserted.
- **Vocabulary** (`grill-me`) — Does every domain term resolve to `.context.md`, meaning the same thing it means there? Does any phase contradict a recorded decision without saying so? A plan that renames a domain concept in passing is changing the domain model without deciding to.
- **Phases** — Can each phase be committed green on its own? Can any of them pass its exit criterion while its goal is unmet? Does any phase depend on one that comes later?
- **Failure** (`distributed-systems`) — Only when the change spans processes or nodes: partition, retry, duplicate delivery, partial failure, and what state survives each.

When the plan fixes a bug, the `diagnose` rule applies: a plan that fixes a cause nobody reproduced is a guess. If the cause is unconfirmed, phase one builds the feedback loop that confirms it.

## 4. Present

Write the plan to `docs/plans/<slug>.md`. When plan mode designates its own plan file, write the same content there so the approval request surfaces it.

Present the phase list, the out-of-scope list, and the findings that changed the plan. Passes that found nothing, phases that were cut, and the order things were read in are not part of it.

Request approval with `ExitPlanMode`. Do not ask whether the plan is acceptable in prose or with `AskUserQuestion` — that is what the tool does.

Once approved, `issues` breaks the plan into tickets and `engineer` executes a phase.

A plan long enough to need a summary is two plans.
