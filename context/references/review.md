# Review

What to test a recorded hierarchy against, and in what order. Source is not read — the subject is the
context files themselves. Everything here is checkable from the tree and the files.

Work outward-in: the shape of the tree, then placement across files, then entries, then decisions. A
misplaced entry rewritten in place is wasted work.

## Tracking

A review tracks itself under `.claude/context/<session>/`, created lazily and deleted when the review is
clean. It shares that directory with a sweep but not its files: a run holding `findings.md` is a review,
one holding `index.md` is a sweep, and neither writes the other's records.

```
.claude/context/<session>/
├── findings.md
└── ledger.md
```

`findings.md` is one row per scope, and the two columns are what keep every check finished before any
repair begins — no `Repaired` box is ticked while a `Checked` box is empty.

```md
# Review: {root scope}

| Scope | Checked | Repaired | Found |
| ----- | ------- | -------- | ----- |
| `internal/order` | x | x | over-scoped ×3, redundant relationship |
| `internal/billing` | x | | undrained parent ×10 |
| `internal/api` | x | | — |
```

`Found` is what the checks turned up, in the words of the check that found it. A scope with an empty
`Found` and a ticked `Checked` passed, and that is worth recording — it is the evidence the checklist
actually ran everywhere rather than stopping at the first large finding.

`ledger.md` follows the sweep's ledger shape. A review reads no source, so its entries stay open.

## Shape

- Every directory holding authored source of its own carries a `.context.md`. A missing one is a finding.
- Generated output carries none. Its language belongs to the scope owning the generator input.
- A directory holding only subdirectories carries one only where it records something true of every
  scope beneath it. A parent file that restates a single child is a finding.
- No `.context.md` sits under a documentation directory. Move its entries to the code they describe.
- Each file carries `## Language` and `## Relationships`. `## Decisions`, `## Example dialogue`, `## Flagged ambiguities`, and `## Defects` appear only where they have content.

## Placement

- **Over-scoped** — entries that do not hold across the whole subtree. Move each down to the scope it
  describes. Test against the subtree, never against the file's length.
- **Undrained parent** — an entry true of exactly one child, where that child already carries its own
  file. The split happened and the entry did not move. Count a parent's terms that exist nowhere below
  it: a file whose children were created from source rather than from it will show almost all of them.
- **Under-scoped** — sibling files carrying the same term with the same meaning. Lift it to the parent.
- **Shadowed** — a child restating an entry its parent already carries. Delete the child copy. Where
  the two meanings differ, the disagreement is the finding, not the duplication.
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
alter or remove recorded language goes to the ledger and then to the user. Creating a file for a scope
that has source and none, and moving an entry to the scope it describes, remove nothing and are done
rather than raised. Splitting an over-scoped file is the fix, never a question for the user — neither
whether to split it nor how much of it to split.

Placement repairs are per-scope judgment work, not a bulk move. Take one receiving scope at a time and
read what it already records before anything lands in it:

- An arriving term naming a concept the scope already has under another word is one term to settle, not
  two to keep.
- An arriving relationship the scope already states in other words is redundant on arrival; the weaker
  of the two goes.
- Two terms whose `_Avoid_` lines name each other need that distinction spelled out once they are
  siblings.
- An arriving line that contradicts one already there is a conflict, not a duplicate. Neither is written;
  the pair goes to the ledger.

Moving everything at once sees none of this and leaves duplicates that read as deliberate. Remove an
entry from its old home only once its new home holds it — the reverse order loses entries outright.

The same checks apply to lines this repair writes, not only to lines it moves.

## Reporting

Report what every check found, including the ones that passed, then what was fixed, what reached the
ledger, and every scope whose file was created or deleted.
