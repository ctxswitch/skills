# Review

What to test a recorded hierarchy against, and in what order. Source is not read — the subject is the
context files themselves. Everything here is checkable from the tree and the files.

Work outward-in: the shape of the tree, then placement across files, then entries, then decisions. A
misplaced entry rewritten in place is wasted work.

## Tracking

A review writes two files of its own plus the shared per-scope records.

```
.claude/context/<session>/
├── findings.md
├── ledger.md
├── internal/
│   └── order.md          ← internal/order
└── pkg/
    └── billing.md        ← pkg/billing
```

`findings.md` is the index — one row per scope, and the two columns are what keep every check finished
before any repair begins. No `Repaired` box is ticked while a `Checked` box is empty.

```md
# Review: {root scope}

| Scope | Checked | Repaired |
| ----- | ------- | -------- |
| `internal/order` | x | x |
| `internal/billing` | x | |
| `internal/api` | x | |
```

The findings themselves go in the per-scope records — `## Checked` for what the checks turned up,
`## Written` for what the repair changed, `## Raised` for what it ledgered.

A scope's `## Checked` names every check that fired and says `clean:` for the groups that passed, so a
later run can tell "checked and fine" from "never checked".

`ledger.md` follows the sweep's ledger shape, and its entries stay open — a review reads no source, so
neither claim in a conflict can be checked against the code. It is this run's working copy, never the
only one: every open entry is also recorded under `## Flagged ambiguities` at the scope it concerns,
because the run directory is deleted and the context file is not.

## Shape

- Every directory holding authored source of its own carries a `.context.md`. A missing one is a finding.
- Generated output carries none. Its language belongs to the scope owning the generator input.
- A directory holding only subdirectories carries one only where it records something true of every
  scope beneath it. A parent file that restates a single child is a finding.
- No `.context.md` sits under a documentation directory. Move its entries to the code they describe.
- A file for a directory holding source carries `## Language`. One for a directory of subdirectories may
  carry only `## Relationships`, where what spans its children is a fact rather than a term — coining a
  term to fill the heading is padding.
- `## Decisions`, `## Example dialogue`, `## Flagged ambiguities`, and `## Defects` appear only where they
  have content.

## Placement

- **Over-scoped** — entries that do not hold across the whole subtree. Move each down to the scope it
  describes. Test against the subtree, never against the file's length.
- **Undrained parent** — an entry true of exactly one child that already carries its own file. Count a
  parent's terms existing nowhere below it; a file whose children were built from source rather than from
  it shows almost all of them.
- **Under-scoped** — sibling files carrying the same term with the same meaning. Lift it to the parent.
- **Shadowed** — a child and an ancestor both carrying the same entry. A fact belongs at exactly one
  scope, so this is evidence an earlier write recorded a fact without draining where it came from. Do not
  resolve it by position: establish which entry is right and which scope owns the fact, keeping that one.
  A child's wording is often better, written closer to the code. Where the two differ in meaning rather
  than wording, neither is deleted — record the disagreement under `## Flagged ambiguities`.
- **Split meaning** — one term defined differently in two scopes. Neither file can settle it; open a
  ledger entry.

## Entries

- One canonical term per concept. A second name for the same thing belongs under `_Avoid_`, not beside it as a peer.
- The definition is one sentence and says what the term is, not what it does.
- A term naming internal structure — a struct, a file, a helper — is a defect unless it carries a responsibility or boundary that constrains change.
- Relationships use bold term names, and state cardinality wherever the code fixes it.
- The name matches the reach of its own definition. A definition reaching wider than its name means the
  term is misnamed, however well the name fits its siblings.
- `_Avoid_` carries the distinction wherever the avoided word names a genuinely different thing.
- No history: migration numbers, issue numbers, dates, release names, "previously X, now Y". A legacy
  path still executing is current behaviour and stays, without the story of how it became legacy.
- The entry reads on its own. Anything needing an issue, a migration, a prior run, or a conversation to
  make sense belongs elsewhere.
- A reason names the mechanism that forces the constraint, not the merit of the decision. Strip clauses
  that argue correctness, rank importance, or replay the reasoning.
- A reason imports no fact another scope owns. Name the term and stop.
- `_Pending_:` marks any term with no code behind it. A term with neither the marker nor code is the
  opposite finding — the code was removed or renamed.
- No heading stands empty. A level carrying no ambiguities or no dialogue has neither section.

## Defects

- Each line is a kind, a `file:line`, and what is wrong — nothing else.
- No entry changes what a recorded term means; one that does belongs in `## Relationships`.
- A review reads no source, so it cannot confirm a fault still exists. Leave the entries alone; the next
  sweep verifies them.

## Decisions

- The line carries the constraint and the rejected alternative, and nothing else.
- The alternative is still one someone would reach for. When it stops being plausible, drop the line —
  `git log` keeps what was removed.
- A decision the code does not yet satisfy is written as intent, not asserted as fact. "The families are
  removed" is false while the families exist; the entry states what must happen, and the description of
  current behaviour elsewhere in the file stays true until the code changes.

## Repairing

The repair rule is the sweep's: a defect that does not change meaning is fixed in place; one that would
alter or remove recorded language goes to the ledger and then to the user.

**Every Placement finding resolves from the scope rule, so none of them is a question.** Where an entry
belongs, and whether a file is created or deleted, follow from where a fact holds and how far — including
*and no shallower*, which stops an over-scoped entry being "fixed" by lifting it too high. Ask only when
two claims contradict and the file cannot say which is true.

These remove nothing and are done rather than raised:

- creating a file for a scope that has source and none
- moving an entry to the scope it describes
- splitting an over-scoped file — neither whether to split it nor how much of it to split
- deleting a shadowed copy, because the scope that owns it still holds it
- deleting a file whose entries have all moved or been shadowed away, since nothing it held is lost

Placement repairs are per-scope judgment work, not a bulk move. Take one receiving scope at a time and
read what it already records before anything lands in it:

- An arriving term naming a concept the scope already has under another word is one term to settle, not
  two to keep.
- An arriving relationship the scope already states in other words is redundant on arrival; the weaker
  of the two goes.
- Two terms whose `_Avoid_` lines name each other need that distinction spelled out once they are
  siblings.
- An arriving line that contradicts one already there is a conflict, not a duplicate. Neither claim
  replaces the other; the disagreement is recorded under `## Flagged ambiguities` at the scope that holds
  it, and tracked in the ledger for this run.

Remove an entry from its old home only once its new home holds it; the reverse order loses entries.
These checks apply to lines this repair writes, not only to lines it moves.

## Reporting

Report what every check found, including the ones that passed, then what was fixed, what reached the
ledger, and every scope whose file was created or deleted.
