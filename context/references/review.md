# Review

What to test a recorded hierarchy against, and in what order. Source is not read — the subject is the
context files themselves. Everything here is checkable from the tree and the files.

Work outward-in: the shape of the tree, then placement across files, then entries, then decisions. A
misplaced entry rewritten in place is wasted work.

## Shape

- Every directory holding authored source of its own carries a `CONTEXT.md`. A missing one is a finding.
- Generated output carries none. Its language belongs to the scope owning the generator input.
- A directory holding only subdirectories carries one only where it records something true of every
  scope beneath it. A parent file that restates a single child is a finding.
- No `CONTEXT.md` sits under a documentation directory. Move its entries to the code they describe.

## Placement

- **Over-scoped** — entries that do not hold across the whole subtree. Move each down to the scope it
  describes. Test against the subtree, never against the file's length.
- **Under-scoped** — sibling files carrying the same term with the same meaning. Lift it to the parent.
- **Shadowed** — a child restating an entry its parent already carries. Delete the child copy. Where
  the two meanings differ, the disagreement is the finding, not the duplication.
- **Split meaning** — one term defined differently in two scopes. Neither file can settle it; open a
  ledger entry.

## Entries

- The definition is one sentence and says what the term is, not what it does.
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

## Decisions

- The line carries the constraint and the rejected alternative, and nothing else.
- The alternative is still one someone would reach for. When it stops being plausible, drop the line —
  `git log` keeps what was removed.
- A decision the code does not yet satisfy is written as intent, not asserted as fact. "The families are
  removed" is false while the families exist; the entry states what must happen, and the description of
  current behaviour elsewhere in the file stays true until the code changes.

## Reporting

The repair rule is the sweep's: a defect that does not change meaning is fixed in place; one that would
alter or remove recorded language goes to the ledger and then to the user. Creating a file for a scope
that has source and none, and moving an entry to the scope it describes, remove nothing and are done
rather than raised.

Report what was fixed, what reached the ledger, and every scope whose file was created or deleted.
