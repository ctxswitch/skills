---
name: context-drift
description: "Rebuild a repository's CONTEXT.md files from current source, working dependencies-first, and surface where code, docs, and recorded language disagree. Use when context has drifted from the code, or a repo has none. For settling a new design's vocabulary in conversation use grill-me."
---

# Context Drift

Rebuild recorded domain language from what the code does now. Code is evidence; docs and existing context are claims about it.

This skill writes documentation. It does not change source. Code defects it exposes are reported and routed to `engineer` or `diagnose`.

## Guard against the defaults

The default failure mode is treating every difference as a conflict and asking the user what the codebase already answers.

- **Do not ask what the codebase answers.** An ambiguity raised in one module is usually settled by a module not yet read. Nothing becomes a question until the sweep is finished and the entry has been re-tested against everything read since.
- **Different words for different things is not a conflict.** A conflict is one term carrying two meanings, one rule implemented two ways, or recorded language the code no longer supports. Modules that never interact can name things freely.
- **Docs are claims, not evidence.** A README, ADR, or CONTEXT.md states what someone intended. Only code states what happens. Where they differ, both go to the user — the doc is not the tiebreaker.
- **A term is defined by the module that owns it**, not by a caller that uses it or a doc that mentions it.
- **Record domain language, not implementation.** A term belongs in `CONTEXT.md` when a domain expert would recognise it. Struct names, handler names, and package layout do not qualify unless they carry a domain invariant or responsibility.

## Tracking the run

Track the run under `.claude/drift/<session>/` — the session identifier where the harness exposes one, a scope slug otherwise — written as you go and deleted when the run completes. Create it lazily. Every file follows the templates in [run-format.md](./references/run-format.md).

- `index.md` — the scope and the dependency-ordered module list, each module pending or swept.
- `ledger.md` — every ambiguity in flight: what the code shows, what the docs claim, what is unresolved, and the evidence gathered since it was raised. Resolved entries stay in the file with their decision and where it was written.
- `<module path>.md` — one per swept module, mirroring the repo tree: the terms it owns, its limits and restrictions, what was written to its context, and the ledger entries it raised.

When a later module bears on an open entry, append that evidence to the entry in `ledger.md` as you read it.

A dependency's file exists before anything depending on it is read. Check a term there before re-reading its source.

Scan `.claude/drift/` before starting. Where an incomplete run covers the requested scope, resume from the first pending module in its `index.md`.

An entry closes from the evidence recorded under it, never from recall.

## 1. Scope the run

Read every `CONTEXT.md` in the scope, plus `CONTEXT-MAP.md` where it exists, then build the internal dependency graph and order it dependencies-first.

Record which directories carry a context file and which inherit. A directory owning language at its own level and recording none is a finding, not an omission to work around.

State the scope and the module count before reading anything else, then record the ordered module list in `index.md`.

## 2. Sweep dependencies-first

A module is read before anything that depends on it. The owner fixes a term's meaning; every later use is measured against that definition.

From the code of each module, establish:

- **Functionality** — the behaviour a caller depends on.
- **Limits** — bounds, quotas, sizes, timeouts, cardinalities, retention.
- **Restrictions** — preconditions, invariants, illegal states, orderings that must hold, authorization points.
- **Terms owned** — the domain concepts this module defines, and what each means here.

Then compare against the module's recorded context and any docs covering it. Three outcomes:

- **Agreement** — nothing to do.
- **Gap** — the code clearly defines a domain term that context does not record, or records nothing at all. Write it.
- **Conflict** — open an entry in `ledger.md`. Do not ask, do not write.

Validate the recorded context against [context-format.md](../grill-me/references/context-format.md) in the same pass:

- **Structure** — `## Language`, `## Relationships`, `## Example dialogue`, `## Flagged ambiguities`, each carrying content.
- **Entries** — one canonical term per concept, its aliases under `_Avoid_`, and a one-sentence definition saying what the term is rather than what it does.
- **Relationships** — bold term names, with cardinality wherever the code fixes it.
- **Scope** — general programming concepts are not domain terms. A recorded term a domain expert would not recognise is a defect.
- **Placement** — a fact belongs at the shallowest directory where it holds for everything beneath it. Move an over-scoped entry down, lift a term repeated identically across siblings to the parent, delete a child that restates its parent, and create a file where a directory owns language recorded nowhere. Where a child and parent disagree, the disagreement is the finding rather than the duplication. A context file under a documentation directory is misfiled — move its entries to the code they describe and delete it.
- **Open items** — an entry under `## Flagged ambiguities` carrying no resolution is a ledger entry, not a format defect.

A format defect that does not change meaning is fixed in place. One that would alter or remove recorded language goes to the ledger.

Divergence introduced over time shows up as two spellings of one concept, or one concept split across two names that both survive. Look for it at every seam where two modules exchange a domain object.

Write the module's file and mark it swept in `index.md` before moving to the next.

## 3. Close the ledger

When the sweep completes, re-test every entry under `## Open` in `ledger.md` against the evidence collected beneath it, re-reading the source the entry names. An entry closes when a later module names the owner, an ADR states the decision, or a second call site disambiguates. Only entries surviving the re-test reach the user.

## 4. Ask what is left

Ask interactively, one decision at a time, each with your recommended answer.

A question carries three things and nothing else:

- what the code does, with `file:line`
- what the docs or context claim
- the decision needed

Rank by blast radius — a term crossing contexts before one local to a module.

The user's answer is the decision. When it contradicts the code, record the decision and report the code as defective; do not edit it.

## 5. Write

Write each fact at the shallowest directory where it holds for everything beneath it, creating the file where a directory owns language and carries none. Use the formats in the `grill-me` skill: [context-format.md](../grill-me/references/context-format.md) and [adr-format.md](../grill-me/references/adr-format.md).

Write each entry as its decision lands, not in a batch at the end. Every ambiguity the user settles is recorded under `## Flagged ambiguities` with its resolution. Offer an ADR only when it is hard to reverse, surprising without context, and the result of a real trade-off.

When every decision is written, delete `.claude/drift/<session>/`.

Report what was written, what the user decided, and every code defect the sweep exposed.
