---
name: context
description: "Build and maintain a repository's CONTEXT.md hierarchy from current source, working dependencies-first, and surface where code, docs, and recorded language disagree. Use to create context for a repo that has none, or to repair it once it has drifted. Owns the context format the other skills write to. For settling a new design's vocabulary in conversation use grill-me."
---

# Context

Build and maintain recorded domain language from what the code does now. Code is evidence; docs and existing context are claims about it.

This skill writes documentation. It does not change source. Code defects it exposes are reported and routed to `engineer` or `diagnose`.

## Guard against the defaults

The default failure mode is treating every difference as a conflict and asking the user what the codebase already answers.

- **Do not ask what the codebase answers.** An ambiguity raised in one scope is usually settled by a scope not yet read. Nothing becomes a question until the sweep is finished and the entry has been re-tested against everything read since.
- **Different words for different things is not a conflict.** A conflict is one term carrying two meanings, one rule implemented two ways, or recorded language the code no longer supports. Scopes that never interact can name things freely.
- **Docs are claims, not evidence.** A README, design doc, or CONTEXT.md states what someone intended. Only code states what happens. Where they differ, both go to the user — the doc is not the tiebreaker. A `_Pending_:` entry is the exception: it claims nothing about code that exists.
- **A term is defined by the scope that owns it**, not by a caller that uses it or a doc that mentions it.
- **Placement is not a preference.** Where an entry belongs follows from the rule, not from taste or the size of the resulting diff. Never offer a choice between splitting an over-scoped file and leaving it — split it and report what moved.
- **Folding a scope into its parent is the mirror failure.** Writing a scope's language into the nearest file that already exists feels conservative and is not — it buries the boundary the language belongs to. The hierarchy's shape is an output of the sweep, never an input to it.
- **Record current behaviour, not the history behind it.** The sweep reads code to learn what happens now. What a migration changed, which issue proposed it, and what the previous shape was are recoverable from `git log`, the migrations, and the tracker — carrying them into a context file makes it a changelog that drifts twice. A legacy path still executing is current behaviour and is recorded as such, without the story of how it became legacy.
- **Record domain language, not implementation.** A term belongs in `CONTEXT.md` when a domain expert would recognise it. Struct names, handler names, and package layout do not qualify unless they carry a domain invariant or responsibility.

## Tracking the run

Track the run under `.claude/drift/<session>/` — the session identifier where the harness exposes one, a scope slug otherwise — written as you go and deleted when the run completes. Create it lazily. Every file follows the templates in [run-format.md](./references/run-format.md).

- `index.md` — the root scope and the dependency-ordered scope list, each scope pending or swept.
- `ledger.md` — every ambiguity in flight: what the code shows, what the docs claim, what is unresolved, and the evidence gathered since it was raised. Resolved entries stay in the file with their decision and where it was written.
- `<scope path>.md` — one per swept scope, mirroring the repo tree: the terms it owns, its limits and restrictions, what was written to its context, and the ledger entries it raised.

When a later scope bears on an open entry, append that evidence to the entry in `ledger.md` as you read it.

A dependency's file exists before anything depending on it is read. Check a term there before re-reading its source.

Scan `.claude/drift/` before starting. Where an incomplete run covers the requested scope, resume from the first pending scope in its `index.md`.

An entry closes from the evidence recorded under it, never from recall.

## 1. Scope the run

A **scope** is a directory that owns language its parent does not. That test is the definition. The shapes it takes are only signals: a package, library, or crate; a deployable or runnable unit; a published interface; a configuration domain; a bounded subdomain inside a larger one.

Do not enumerate by a language's own unit. "Module" names a different thing in Go, Rust, Python, and npm, and a repo's scopes rarely line up with any of them — a whole repo is often one Go module. A scope need not hold a programming language at all: protocol definitions, infrastructure roots, and deployment packaging own language too.

Walk the tree, enumerate candidate scopes from the sources, build the dependency graph over them, and order it dependencies-first. Read the existing `CONTEXT.md` files only after that list is fixed.

Existing files never bound the list. A scope owning language and carrying no file is a finding to write, not a scope to fold into its parent.

State the root scope and the scope count before reading anything else, then record the ordered scope list in `index.md`.

## 2. Sweep dependencies-first

A scope is read before anything that depends on it. The owner fixes a term's meaning; every later use is measured against that definition.

From the sources of each scope, establish:

- **Functionality** — the behaviour a caller depends on.
- **Limits** — bounds, quotas, sizes, timeouts, cardinalities, retention.
- **Restrictions** — preconditions, invariants, illegal states, orderings that must hold, authorization points.
- **Terms owned** — the domain concepts this scope defines, and what each means here.

Then compare against the scope's recorded context and any docs covering it. Three outcomes:

- **Agreement** — nothing to do.
- **Gap** — the sources clearly define a domain term that context does not record, or the scope records nothing at all. Write it. Where the scope carries no `CONTEXT.md`, creating one is how the gap is written, not a separate decision to defer.
- **Conflict** — open an entry in `ledger.md`. Do not ask, do not write.

An entry marked `_Pending_:` is intent, not a description, and is never drift. Check one thing: whether the code has arrived. If it has, drop the marker, move the entry to the level that now owns it, and reconcile it like any other. If it has not, leave it and carry it forward as pending. A term carrying no `_Pending_:` and no code behind it is the opposite finding — the code was removed or renamed — and opens a ledger entry.

Validate the recorded context against [context-format.md](./references/context-format.md) in the same pass:

- **Structure** — `## Language`, `## Relationships`, `## Example dialogue`, `## Flagged ambiguities`, each carrying content.
- **Entries** — one canonical term per concept, its aliases under `_Avoid_`, and a one-sentence definition saying what the term is rather than what it does.
- **Relationships** — bold term names, with cardinality wherever the code fixes it.
- **Scope** — general programming concepts are not domain terms. A recorded term a domain expert would not recognise is a defect.
- **Placement** — a fact belongs at the shallowest directory where it holds for everything beneath it. Move an over-scoped entry down, lift a term repeated identically across siblings to the parent, and delete a child that restates its parent. Where a child and parent disagree, the disagreement is the finding rather than the duplication. A context file under a documentation directory is misfiled — move its entries to the code they describe and delete it.
- **Over-scope** — test a file's entries against its whole subtree, never its length. Entries holding for only part of what sits beneath it mean the file is over-scoped, and the fix is moving each one down to the scope it describes. Split it as you sweep. A file that grew while its subtree gained scopes is the signal to run this check, not a reason to cut words.
- **Open items** — an entry under `## Flagged ambiguities` carrying no resolution is a ledger entry, not a format defect.

A format defect that does not change meaning is fixed in place. Only altering what a term means, or dropping recorded language altogether, reaches the ledger.

Relocation is neither. Creating a file for a scope that owns unrecorded language, and moving an entry down to the scope it describes, preserve every word — both are carried out during the sweep. Splitting an over-scoped file is the fix, never a question for the user.

Divergence introduced over time shows up as two spellings of one concept, or one concept split across two names that both survive. Look for it at every seam where two scopes exchange a domain object.

Write the scope's file and mark it swept in `index.md` before moving to the next.

## 3. Close the ledger

When the sweep completes, re-test every entry under `## Open` in `ledger.md` against the evidence collected beneath it, re-reading the source the entry names. An entry closes when a later scope names the owner, a recorded decision settles it, or a second call site disambiguates. Only entries surviving the re-test reach the user.

## 4. Ask what is left

Ask interactively, one decision at a time, each with your recommended answer.

A question must be answerable without opening the repo. It carries these and nothing else:

- the recorded entry quoted verbatim with its `file:line` — the definition, never the term's name alone
- any entry the wording deliberately pairs with or contrasts against, quoted the same way; a name that looks wrong in isolation is often fixed by the term it disambiguates against
- what the code does, with `file:line`
- where the recorded entry came from, whenever the question is about existing language — `git log -S` the entry and say whether it arrived with a code change, with a prior sweep, or before the file's history
- the decision needed

A term a prior sweep introduced with nothing in the sources behind it is not a naming question. Ask whether it should exist at all, and say that is what you are asking.

Rank by blast radius — a term crossing contexts before one local to a scope.

The user's answer is the decision. When it contradicts the code, record the decision and report the code as defective; do not edit it.

## 5. Write

Write each fact at the shallowest directory where it holds for everything beneath it, creating the file where a scope owns language and carries none. Use the format in [context-format.md](./references/context-format.md).

Write each entry as its decision lands, not in a batch at the end. Every ambiguity the user settles is recorded under `## Flagged ambiguities` with its resolution. Record a decision only while someone would still reach for the alternative — `_Fixed_:` on the term it governs, or the scope's `## Decisions` section. Drop a recorded decision whose alternative nobody would now propose.

When every decision is written, delete `.claude/drift/<session>/`.

Report what was written, what the user decided, every entry still pending, and every code defect the sweep exposed.
