---
name: context
description: "Build and maintain a repository's .context.md hierarchy from current source, working dependencies-first, and surface where code, docs, and recorded language disagree. Use to create context for a repo that has none, or to repair it once it has drifted. Invoke with `review` to test an existing hierarchy against the format without reading source, `defects` to collect the code faults it has recorded and group them into work, or `optimize` to propose maintainability changes to the codebase from the domain model the hierarchy holds. Owns the context format the other skills write to. For settling a new design's vocabulary in conversation use grill-me."
---

# Context

Build and maintain recorded domain language from what the code does now. Code is evidence; docs and existing context are claims about it.

This skill writes documentation. It does not change source. Code defects it exposes are reported and routed to `engineer` or `diagnose`.

## Modes

**Sweep** is the default and runs all seven steps, crossing the scope list twice — extract, then reconcile. It is the only mode that finds drift between code and context, and the expensive one.

**Review** runs step 7 alone. It opens no source file, tests the recorded hierarchy against the format, and finds what a sweep introduces but never looks for: entries at the wrong level, names that outrun their definitions, narration, scopes holding source and no file. Invoke it with `review`.

**Defects** collects the `## Defects` entries already recorded across a hierarchy and groups them into work by cause rather than by file — a dozen citations of one deleted document are one job, not a dozen. It reads no source, repairs nothing, and writes nothing to a context file. Invoke it with `defects`, or when asked to scan for defects and plan the fixes. Each entry is re-verified by whoever acts on the plan, since entries outlive the run that recorded them; hand the grouping to `issues` to file.

**Optimize** proposes maintainability changes to the codebase out of what the hierarchy records — a boundary whose compensation shows up as best-effort drains and retries, one concept built twice under two names, a scope everything reaches into, a seam neither side can change alone. It reads the whole hierarchy rather than measuring over it, since every move is a judgement about what two entries mean, then ranks by blast radius and verifies only the top of that list against source; the rest are candidates carrying the check that would settle them. It is the one mode whose subject is the code rather than the files, and it still changes neither. Invoke it with `optimize`, or when asked what would make the codebase more maintainable. Follow [optimize.md](./references/optimize.md).

## Guard against the defaults

The default failure mode is treating every difference as a conflict and asking the user what the codebase already answers.

- **Do not ask what the codebase answers.** An ambiguity raised in one scope is usually settled by a scope not yet read — which is why extraction finishes before reconciliation begins. Nothing becomes a question until pass two is finished and the entry has been re-tested against everything read since.
- **Different words for different things is not a conflict.** A conflict is one term carrying two meanings, one rule implemented two ways, or recorded language the code no longer supports. Scopes that never interact can name things freely.
- **Docs are claims, not evidence.** A README, design doc, or .context.md states what someone intended. Only code states what happens. Where they differ, both go to the user — the doc is not the tiebreaker. A `_Pending_:` entry is the exception: it claims nothing about code that exists.
- **A term is defined by the scope that owns it**, not by a caller that uses it or a doc that mentions it.
- **Placement is not a preference, and neither is its scale.** Where an entry belongs follows from the rule, not from taste, diff size, or how many scopes it touches. Never offer a choice between splitting an over-scoped file and leaving it, nor between splitting now and splitting some later.
- **Folding a scope into its parent is the mirror failure.** The hierarchy's shape is an output of the sweep, never an input to it.
- **Record current behaviour, not the history behind it.** What a migration changed and which issue proposed it live in `git log` and the tracker. A legacy path still executing is current behaviour and is recorded as such.
- **Record what callers rely on, not how it is built.** An entry names a concept, contract, or invariant a caller must hold. Internal structure qualifies only where it carries a responsibility or boundary that constrains change; "would a domain expert recognise it" is too narrow, discarding the architectural terms that carry writer boundaries.

## Tracking the run

Track every run under `.claude/context/<session>/` — the session identifier where the harness exposes one, otherwise a name no directory there already holds — written as you go and deleted when the run completes. Create it before the first directory is examined.

A sweep writes the files in [sweep-format.md](./references/sweep-format.md); a review writes the ones in [review.md](./references/review.md). The two never mix, so a directory holding `index.md` is a sweep to resume and one holding `findings.md` is a review.

These files are the run's memory, not a report on it. A sweep over a large repository will not fit in one context: assume compaction at any point, and treat everything not yet written under `.claude/context/<session>/` as lost.

**Everything found is stored as it is found, negative results included** — a directory ruled out and why, a scope examined and clean, a term considered and rejected. Pass two reconciles against what pass one stored, so an unstored finding is not a missing note but a comparison that cannot happen. A rebuild seeing only survivors re-derives them and reaches the same rejections again.

**Closing a scope is the gate on opening the next one, not a chore at the end of the current one.** Before any file of the next scope is read, the previous scope's record and its box must already be on disk. Written as a trailing step it is dropped in batches, and everything between the work and the account of it is unrecoverable.

Pass one ticks `Extracted` once the scope record is written.

Pass two ticks `Reconciled` only once the scope's `.context.md` exists, its comparison outcome is recorded there or in the ledger, and the scope record carries `## Checked`, `## Written`, and `## Raised`. Deciding what a file should contain is not the same as the file containing it.

An unticked box makes finished work invisible to the rebuild; a ticked box with nothing behind it makes the rebuild skip a scope it never did. Never tick what you have not written.

- `index.md` — the root scope and the dependency-ordered scope list, each scope carrying an extracted box and a reconciled box.
- `ledger.md` — every ambiguity in flight: what the code shows, what the docs claim, what is unresolved, and the evidence gathered since it was raised. Resolved entries stay in the file with their decision and where it was written.
- `<scope path>.md` — one per scope, mirroring the repo tree: the terms it owns and its limits and restrictions from pass one, then what the checks found, what was written to its context, and the ledger entries it raised from pass two. A review writes the same record at the same path, minus the sections that come from source.

When a later scope bears on an open entry, append that evidence to the entry in `ledger.md` as you read it.

A dependency's scope record exists before anything depending on it is read. Take a term's meaning from that record rather than re-deriving it from the dependency's source.

**A run rebuilds only from its own session's directory, and a new session starts clean.** Rebuilding recovers work this run lost to compaction; another session's directory is that run's memory, and adopting it resumes someone else's work in place of what was asked for. Never read, write, or delete one — it may be in flight. Nothing is lost by leaving it, since every open entry is also under `## Flagged ambiguities` at the scope it concerns.

Rebuild before reading anything else. For a sweep that means `index.md` for which pass each scope has reached, `ledger.md` for the entries in flight, and the scope records for the terms pass one established; for a review, `findings.md` for which scopes are checked and repaired and the scope records for what the checks found. Resume at the first scope whose current phase is unticked — never restart a run this session has already begun.

An entry closes from the evidence recorded under it, never from recall.

## 1. Scope the run

A **scope** is a directory holding authored source of its own — a package, library, or crate; a deployable or runnable unit; a published interface; a configuration domain; a bounded subdomain inside a larger one. A directory holding only subdirectories is a scope only where something is true of every scope beneath it. Generated output is never a scope.

Do not enumerate by a language's own unit — "module" means something different in each, and a whole repo is often one Go module. A scope need not hold a programming language at all: protocol definitions, infrastructure roots, and deployment packaging own language too.

Walk the tree, writing each candidate to `index.md` as it is decided — kept, or excluded with the reason. Build the dependency graph over what is kept and order it dependencies-first. Existing `.context.md` files are not read here; pass two opens them.

Existing files never bound the list. A scope holding source and carrying no file is a finding to write, not a scope to fold into its parent.

State the root scope and the scope count before reading anything else. `index.md` already holds every candidate by then; the dependency order is written into it as the graph resolves.

## 2. Extract from source — pass one

A scope is read before anything that depends on it. The owner fixes a term's meaning; every later use is measured against that definition.

From the sources of each scope, establish:

- **Functionality** — the behaviour a caller depends on.
- **Limits** — bounds, quotas, sizes, timeouts, cardinalities, retention.
- **Restrictions** — preconditions, invariants, illegal states, orderings that must hold, authorization points.
- **Terms owned** — the domain concepts this scope defines, and what each means here.

**Recorded context is not opened in this pass**, with one exception: its `## Defects` section, checked against the source in front of you so surviving faults are not rediscovered and fixed ones are dropped in pass two. Nothing else in the file is read, nothing is compared, nothing is written, and no ledger entry is raised — reading further anchors the extraction to what someone already wrote.

Write the scope's record and tick its extracted box before reading the next scope.

## 3. Reconcile against recorded language — pass two

Only now open the recorded context. Every scope's terms are established, so ownership is decidable from the records rather than deferred.

Work the same dependency order. For each scope, compare its record against its `.context.md` and any docs covering it. Three outcomes:

- **Agreement** — nothing to do.
- **Gap** — the sources define a term context does not record, or the scope records nothing at all. Write it. Where the scope carries no `.context.md`, creating one is how the gap is written, not a separate decision to defer.
- **Conflict** — open an entry in `ledger.md`. Do not ask, do not write.

Creating a scope's file and draining its parent are one operation: every entry an ancestor holds that is true only of this scope moves into the new file and out of the ancestor, in the same step. A parent still carrying a child's language after that child has a file is the over-scope defect surviving the split.

Drain one scope at a time, reading what it already records before anything lands in it. An arriving term naming a concept the scope already has under another word is one term to settle. An arriving relationship already stated in other words is redundant, and the weaker goes. Two arriving terms whose `_Avoid_` lines name each other need that distinction spelled out.

A term two scopes appear to share is settled here, not parked — pass one recorded both sides.

An entry marked `_Pending_:` is intent, not a description, and is never drift. Check one thing: whether the code has arrived. If it has, drop the marker, move the entry to the level that now owns it, and reconcile it like any other. If it has not, leave it and carry it forward as pending. A term carrying no `_Pending_:` and no code behind it is the opposite finding — the code was removed or renamed — and opens a ledger entry.

Run the checks in [review.md](./references/review.md) against each scope as you reconcile it, applying the repair rule stated there. Two further checks belong here, because both need what only this pass holds:

- **Open items** — an entry under `## Flagged ambiguities` carrying no resolution is an open question, not a format defect. Track it in `ledger.md` for this run, but it stays in the scope's `## Flagged ambiguities` where a later reader will meet it.
- **Divergence** — two spellings of one concept, or one concept split across two surviving names. Look at every seam where two scopes exchange a domain object; pass one recorded both sides, so the seam is visible without re-reading either.

Rewrite the scope's `## Defects` section from what pass one verified: the faults still present, plus any this pass exposed, and nothing that has since been fixed.

Append `## Checked`, `## Written`, and `## Raised` to the scope's record, then tick its reconciled box — both before moving to the next scope. Pass two produces three artifacts per scope: the edit, the record of it, and the tick.

## 4. Close the ledger

When pass two completes, re-test every entry under `## Open` in `ledger.md` against the evidence collected beneath it, re-reading the source the entry names. An entry closes when a later scope names the owner, a recorded decision settles it, or a second call site disambiguates. Only entries surviving the re-test reach the user.

## 5. Ask what is left

Ask interactively, one decision at a time, each with your recommended answer.

A question must be answerable without opening the repo. It carries these and nothing else:

- the recorded entry quoted verbatim with its `file:line` — the definition, never the term's name alone
- any entry the wording pairs with or contrasts against, quoted the same way — a name that looks wrong alone is often fixed by the term it disambiguates against
- what the code does, with `file:line`
- where the recorded entry came from, whenever the question is about existing language — `git log -S` the entry and say whether it arrived with a code change, with a prior sweep, or before the file's history
- the decision needed

A term a prior sweep introduced with nothing in the sources behind it is not a naming question. Ask whether it should exist at all, and say that is what you are asking.

Never bundle items whose answers diverge. Entries sharing a symptom rarely share a cause, and one question over all of them forces a single verdict onto several findings.

Rank by blast radius — a term crossing contexts before one local to a scope.

The user's answer is the decision. When it contradicts the code, record the decision and report the code as defective; do not edit it.

## 6. Write

Write each fact at the shallowest directory where it holds for everything beneath it, creating a file for any scope that holds authored source and carries none. Use the format in [context-format.md](./references/context-format.md).

Write each entry as its decision lands, not in a batch at the end. Every ambiguity the user settles is recorded under `## Flagged ambiguities` with its resolution. Record a decision only while someone would still reach for the alternative — `_Fixed_:` on the term it governs, or the scope's `## Decisions` section. Drop a recorded decision whose alternative nobody would now propose.

Report what was written, what the user decided, every entry still pending, and every code defect exposed, naming the scope whose `## Defects` section carries each one.

## 7. Review

Test the hierarchy against [review.md](./references/review.md), which lists the checks, the order to run them, and how each is repaired. No source is read here; the subject is the context files.

A sweep reviews only the scopes it wrote — its own output, before the run directory goes. A standalone review covers every scope beneath its root, and starts here.

**Run every check before repairing anything**, and report what each found including the ones that passed. Interleaving means the first large finding ends the review with the checklist unrun.

State the size of the repair before starting it — one placement finding can mean rewriting every file in the scope.

When repair finishes, re-run the checks that failed. A repair that has not been re-tested is a claim, not a result.

A review reads no source, so a conflict it finds stays open in `ledger.md` until a sweep settles it. Say so when reporting.

When the review is clean, delete `.claude/context/<session>/`.
