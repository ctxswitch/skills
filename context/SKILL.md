---
name: context
description: "Build and maintain a repository's .context.md hierarchy from current source, working dependencies-first, and surface where code, docs, and recorded language disagree. Use to create context for a repo that has none, or to repair it once it has drifted. Invoke with `review` to test an existing hierarchy against the format without reading source — placement, naming, narration, and missing or padded scopes. Owns the context format the other skills write to. For settling a new design's vocabulary in conversation use grill-me."
---

# Context

Build and maintain recorded domain language from what the code does now. Code is evidence; docs and existing context are claims about it.

This skill writes documentation. It does not change source. Code defects it exposes are reported and routed to `engineer` or `diagnose`.

## Modes

**Sweep** is the default and runs all seven steps, crossing the scope list twice — extract, then reconcile. It is the only mode that finds drift between code and context, and the expensive one.

**Review** runs step 7 alone. It opens no source file, tests the recorded hierarchy against the format, and finds what a sweep introduces but never looks for: entries at the wrong level, names that outrun their definitions, narration, scopes holding source and no file. Invoke it with `review`.

## Guard against the defaults

The default failure mode is treating every difference as a conflict and asking the user what the codebase already answers.

- **Do not ask what the codebase answers.** An ambiguity raised in one scope is usually settled by a scope not yet read — which is why extraction finishes before reconciliation begins. Nothing becomes a question until pass two is finished and the entry has been re-tested against everything read since.
- **Different words for different things is not a conflict.** A conflict is one term carrying two meanings, one rule implemented two ways, or recorded language the code no longer supports. Scopes that never interact can name things freely.
- **Docs are claims, not evidence.** A README, design doc, or .context.md states what someone intended. Only code states what happens. Where they differ, both go to the user — the doc is not the tiebreaker. A `_Pending_:` entry is the exception: it claims nothing about code that exists.
- **A term is defined by the scope that owns it**, not by a caller that uses it or a doc that mentions it.
- **Placement is not a preference, and neither is its scale.** Where an entry belongs follows from the rule — not from taste, not from the size of the resulting diff, not from how many scopes it touches. Never offer a choice between splitting an over-scoped file and leaving it, nor between splitting it now and splitting some of it later. Every entry moves where the rule puts it; report what moved.
- **Folding a scope into its parent is the mirror failure.** Writing a scope's language into the nearest file that already exists feels conservative and is not — it buries the boundary the language belongs to. The hierarchy's shape is an output of the sweep, never an input to it.
- **Record current behaviour, not the history behind it.** The sweep reads code to learn what happens now. What a migration changed, which issue proposed it, and what the previous shape was are recoverable from `git log`, the migrations, and the tracker — carrying them into a context file makes it a changelog that drifts twice. A legacy path still executing is current behaviour and is recorded as such, without the story of how it became legacy.
- **Record what callers rely on, not how it is built.** An entry names a concept, contract, or invariant a caller must hold to use the scope correctly. Internal structure — struct names, file layout, helper names — qualifies only where it carries a responsibility or boundary that constrains change. "Would a domain expert recognise it" is too narrow a test: it discards the architectural terms that carry writer boundaries.

## Tracking the run

Track every run under `.claude/context/<session>/` — the session identifier where the harness exposes one, a scope slug otherwise — written as you go and deleted when the run completes. Create it lazily.

A sweep writes the files in [sweep-format.md](./references/sweep-format.md); a review writes the ones in [review.md](./references/review.md). The two never mix, so a directory holding `index.md` is a sweep to resume and one holding `findings.md` is a review.

These files are the run's memory, not a report on it. A sweep over a large repository will not fit in one context: assume compaction at any point, and treat everything not yet written under `.claude/context/<session>/` as lost.

A scope is finished in a pass when that pass's work is on disk **and** its box for that pass is ticked in `index.md` — both before the next scope is read, never batched once the pass is over.

Pass one ticks `Extracted` once the scope record is written.

Pass two ticks `Reconciled` only once all three of these are true: the scope's `.context.md` exists, its comparison outcome is recorded — in that file or in the ledger — and the scope record carries `## Checked`, `## Written`, and `## Raised`. A scope whose file has not been created yet is not reconciled, however much comparing has been done. Deciding what a file should contain is not the same as the file containing it.

An unticked box makes finished work invisible to the rebuild, which redoes the scope. A ticked box with nothing behind it is worse: the rebuild trusts it, skips the scope, and the findings are gone. Never tick what you have not written.

- `index.md` — the root scope and the dependency-ordered scope list, each scope carrying an extracted box and a reconciled box.
- `ledger.md` — every ambiguity in flight: what the code shows, what the docs claim, what is unresolved, and the evidence gathered since it was raised. Resolved entries stay in the file with their decision and where it was written.
- `<scope path>.md` — one per scope, mirroring the repo tree: the terms it owns and its limits and restrictions from pass one, then what the checks found, what was written to its context, and the ledger entries it raised from pass two. A review writes the same record at the same path, minus the sections that come from source.

When a later scope bears on an open entry, append that evidence to the entry in `ledger.md` as you read it.

A dependency's scope record exists before anything depending on it is read. Take a term's meaning from that record rather than re-deriving it from the dependency's source.

Rebuild from the run directory before reading anything else, both after compaction and when `.claude/context/` already holds an incomplete run covering the requested scope. For a sweep that means `index.md` for which pass each scope has reached, `ledger.md` for the entries in flight, and the scope records for the terms pass one established; for a review, `findings.md` for which scopes are checked and repaired and the scope records for what the checks found. Resume at the first scope whose current phase is unticked — never restart a run that has a directory.

An entry closes from the evidence recorded under it, never from recall.

## 1. Scope the run

A **scope** is a directory holding authored source of its own — a package, library, or crate; a deployable or runnable unit; a published interface; a configuration domain; a bounded subdomain inside a larger one. A directory holding only subdirectories is a scope only where something is true of every scope beneath it. Generated output is never a scope.

Do not enumerate by a language's own unit. "Module" names a different thing in Go, Rust, Python, and npm, and a repo's scopes rarely line up with any of them — a whole repo is often one Go module. A scope need not hold a programming language at all: protocol definitions, infrastructure roots, and deployment packaging own language too.

Walk the tree, enumerate candidate scopes from the sources, build the dependency graph over them, and order it dependencies-first. Existing `.context.md` files are not read here; pass two opens them.

Existing files never bound the list. A scope holding source and carrying no file is a finding to write, not a scope to fold into its parent.

State the root scope and the scope count before reading anything else, then record the ordered scope list in `index.md`.

## 2. Extract from source — pass one

A scope is read before anything that depends on it. The owner fixes a term's meaning; every later use is measured against that definition.

From the sources of each scope, establish:

- **Functionality** — the behaviour a caller depends on.
- **Limits** — bounds, quotas, sizes, timeouts, cardinalities, retention.
- **Restrictions** — preconditions, invariants, illegal states, orderings that must hold, authorization points.
- **Terms owned** — the domain concepts this scope defines, and what each means here.

**Recorded context is not opened in this pass**, with one exception: its `## Defects` section, read to check each entry against the source in front of you. Note which faults survive and which are gone — the ones still present are not rediscovered, and the fixed ones are dropped when the section is rewritten in pass two. Nothing else in the file is read, nothing is compared, nothing is written to a `.context.md`, and no ledger entry is raised for a disagreement — there is nothing yet to disagree with.

Reading further anchors the extraction to what someone already wrote, and forces ownership questions before the scopes that would settle them have been read.

Write the scope's record and tick its extracted box before reading the next scope.

Pass one ends with every scope's terms, limits, and restrictions on disk, derived from source alone.

## 3. Reconcile against recorded language — pass two

Only now open the recorded context. Every scope's terms are established, so ownership is decidable from the records rather than deferred.

Work the same dependency order. For each scope, compare its record against its `.context.md` and any docs covering it. Three outcomes:

- **Agreement** — nothing to do.
- **Gap** — the sources define a term context does not record, or the scope records nothing at all. Write it. Where the scope carries no `.context.md`, creating one is how the gap is written, not a separate decision to defer.
- **Conflict** — open an entry in `ledger.md`. Do not ask, do not write.

Creating a scope's file and draining its parent are one operation. As the file is created, every entry an ancestor holds that is true only of this scope moves into it and out of the ancestor, in the same step. Populating a new file from the sources while leaving the parent's copy in place creates the duplication the hierarchy exists to prevent, and a parent still carrying a child's language after that child has a file is the over-scope defect surviving the split rather than progress against it.

Drain one scope at a time, and read what that scope already records before anything lands in it. An arriving term naming a concept the scope already has under another word is one term to settle, not two to keep. An arriving relationship the scope already states in different words is redundant on arrival, and the weaker of the two goes. Two arriving terms whose `_Avoid_` lines name each other need that distinction spelled out, because they are now siblings. Moving every entry in one sweep sees none of this and leaves a target holding duplicates that read as deliberate.

A term two scopes appear to share is settled here, not parked. Pass one recorded both sides, so the owner is decidable from the records without re-reading source.

An entry marked `_Pending_:` is intent, not a description, and is never drift. Check one thing: whether the code has arrived. If it has, drop the marker, move the entry to the level that now owns it, and reconcile it like any other. If it has not, leave it and carry it forward as pending. A term carrying no `_Pending_:` and no code behind it is the opposite finding — the code was removed or renamed — and opens a ledger entry.

Run the checks in [review.md](./references/review.md) against each scope as you reconcile it, applying the repair rule stated there. Two further checks belong here, because both need what only this pass holds:

- **Open items** — an entry under `## Flagged ambiguities` carrying no resolution is a ledger entry, not a format defect.
- **Divergence** — two spellings of one concept, or one concept split across two surviving names. Look at every seam where two scopes exchange a domain object; pass one recorded both sides, so the seam is visible without re-reading either.

Rewrite the scope's `## Defects` section from what pass one verified: the faults still present, plus any this pass exposed, and nothing that has since been fixed.

Append `## Checked`, `## Written`, and `## Raised` to the scope's record, then tick its reconciled box in `index.md` — both before moving to the next scope. Pass two produces three artifacts per scope: the edit to the `.context.md`, the record of what that edit was, and the tick. Only the first survives outside the run directory, and it is the one the rebuild cannot see.

## 4. Close the ledger

When pass two completes, re-test every entry under `## Open` in `ledger.md` against the evidence collected beneath it, re-reading the source the entry names. An entry closes when a later scope names the owner, a recorded decision settles it, or a second call site disambiguates. Only entries surviving the re-test reach the user.

## 5. Ask what is left

Ask interactively, one decision at a time, each with your recommended answer.

A question must be answerable without opening the repo. It carries these and nothing else:

- the recorded entry quoted verbatim with its `file:line` — the definition, never the term's name alone
- any entry the wording deliberately pairs with or contrasts against, quoted the same way; a name that looks wrong in isolation is often fixed by the term it disambiguates against
- what the code does, with `file:line`
- where the recorded entry came from, whenever the question is about existing language — `git log -S` the entry and say whether it arrived with a code change, with a prior sweep, or before the file's history
- the decision needed

A term a prior sweep introduced with nothing in the sources behind it is not a naming question. Ask whether it should exist at all, and say that is what you are asking.

Never bundle items whose answers diverge. Several entries sharing a symptom rarely share a cause — one may be a library object recorded as language, another shadowed by a parent that already says it, a third correct but thinly written. A single question over all of them forces one verdict onto three findings. Split them, or ask about the one and name the rest as separate entries.

Rank by blast radius — a term crossing contexts before one local to a scope.

The user's answer is the decision. When it contradicts the code, record the decision and report the code as defective; do not edit it.

## 6. Write

Write each fact at the shallowest directory where it holds for everything beneath it, creating a file for any scope that holds authored source and carries none. Use the format in [context-format.md](./references/context-format.md).

Write each entry as its decision lands, not in a batch at the end. Every ambiguity the user settles is recorded under `## Flagged ambiguities` with its resolution. Record a decision only while someone would still reach for the alternative — `_Fixed_:` on the term it governs, or the scope's `## Decisions` section. Drop a recorded decision whose alternative nobody would now propose.

Report what was written, what the user decided, every entry still pending, and every code defect the sweep exposed — naming the scope whose `## Defects` section now carries each one, so the report is a pointer to durable entries rather than the only record of them.

## 7. Review

Test the hierarchy against [review.md](./references/review.md), which lists the checks, the order to run them, and how each is repaired. No source is read here; the subject is the context files.

A sweep reviews only the scopes it wrote — its own output, before the run directory goes. A standalone review covers every scope beneath its root, and starts here.

**Run every check before repairing anything.** Diagnosis is cheap and finite; repair is neither. Interleaving them means the first large finding ends the review with the rest of the checklist unrun. Report what every check found — including the ones that passed — then repair.

State the size of the repair before starting it. A single placement finding can mean rewriting every file in the scope, and that is worth naming rather than discovering an hour in.

When repair finishes, re-run the checks that failed. A repair that has not been re-tested is a claim, not a result.

A review reads no source, so a conflict it finds cannot be closed here — neither claim can be checked against the code. Those entries go to `ledger.md` and stay open until a sweep settles them. Say so when reporting, rather than leaving a reader expecting resolution.

When the review is clean, delete `.claude/context/<session>/`.
