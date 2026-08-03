# Restructure

Propose changes to how the code is organised, from what the recorded hierarchy says about the domain.
The output is moves — collapse this, deepen that, give this concept a home — not observations.

The hierarchy is the only artifact holding the whole domain model at a readable size, which is what makes
this possible over a repository too large to read. It is a summary of what callers rely on, so it can say
where boundaries sit wrongly. It cannot say anything about how the code is built: dead code beyond the
`## Defects` entries, duplicated implementation, performance, coupling at the import level, and test gaps
are all invisible here. A request for those is declined rather than guessed at.

## Reading the hierarchy

Read every `.context.md` beneath the root. A whole repository's recorded language runs to a fraction of
the source it describes, which is the entire reason this mode is possible on a codebase too large to read
— the domain model fits in one context even where the code never will. Read it, rather than computing over
it. Every move below is a judgement about what two definitions mean, and a match on term names answers a
different question than the one being asked.

Read scope by scope, and hold the definitions of scopes that exchange a domain object side by side. What
raises a move is one definition read against another, so a pass that summarises each file alone finds
nothing.

## Moves

- **Twin** — two scopes whose terms read as one set with a word substituted through it, each definition
  having a counterpart differing only in the axis that separates them. One concept built twice and
  parameterised by hand. Usually the largest move available, and invisible to anything matching names,
  because the names differ by construction.
- **Facet** — one name carrying both a representation and the behaviour it represents, in two scopes. Both
  are real, so neither is deleted; the representation side takes a suffix naming what it is. Where the
  hierarchy already has such a convention, the finding is which terms break it rather than what to call
  them.
- **Home** — a term several scopes use and none defines. The concept is real and each user realises it
  however it needs. Give it an owning scope, or establish that the scopes mean different things by one
  word.
- **Deepen** — a scope owning many terms that fall into clusters with little language between them. The
  scope carries several responsibilities under one boundary. Split it along the clusters.
- **Collapse** — a scope whose language is referenced by exactly one neighbour, or which owns almost none
  of its own. The directory is a boundary the domain does not have.

**Collapse proposes a change to code, and never to where language is recorded.** The sweep's rule stands
untouched: a scope holding source gets a file, and folding its language into a parent to avoid creating
one is the mirror failure. This proposes that two directories should become one, after which a sweep
records whatever shape results. Never resolve a Collapse by deleting a context file.

## Ranking

Rank by blast radius — how many scopes the move touches, then how many terms move with it. A Home for a
term four scopes reference outranks a Collapse of one leaf. Report the ranking before verifying anything,
so the choice of what got checked is visible.

## Verifying

Take the highest-ranked moves and open the source each one names — three to five, and say how many were
verified and how many were not. The search is cheap because the hierarchy is small; reading source is not,
which is why only the top of the list earns it.

**An unverified move is labelled as one.** A context file records what someone wrote about the code, which
is a claim and not evidence. Every move below the verified cut is reported as a candidate carrying the
check that would settle it.

The common false positive is a scope that documents a neighbour's vocabulary rather than owning it, which
reads as shared language where there is only a copy. That is a placement defect for a review to repair,
not a code change. Rule it out first — it is the cheapest check and the most likely explanation.

What settles each move:

- **Twin** — whether the two implementations share structure, or the parallel language describes
  mechanisms that only sound alike. Parallel vocabulary is cheap to write and proves nothing on its own.
- **Facet** — whether the two definitions describe one thing at different levels or two things that
  collided on a name. Only the first is a rename.
- **Home** — whether a scope already implements the concept without recording it. If one does, the move is
  to record it there; only if none does is there something to build.
- **Deepen** — whether the clusters correspond to separable files, or to one tangled unit.
- **Collapse** — whether anything outside the neighbouring scope depends on it.

## Tracking

Track under `.claude/context/<session>/` like the other modes. A restructure writes `moves.md`, appending
each move as it is raised and each scope to `## Read` as it is read — the reading is the expensive part
and a move raised but unwritten is lost with the context that held it.

```md
# Restructure: {root scope}

| Move | Scopes | Radius | Verified |
| ---- | ------ | ------ | -------- |
| Twin: secret / variable | 4 | 12 | x |
| Home: **Run** | 3 | 3 | |

## Read

- `internal/order` — 8 terms, nothing raised
```

A scope read and raising nothing is recorded saying so, or a resumed run cannot tell it from one never
opened.

## Reporting

Report how many scopes were read and how many raised nothing, then every move in rank order, each carrying
what raised it, the scopes it touches, the proposed change, and either what verification found or the
check still outstanding.

Nothing is written to a `.context.md` and no source is changed. Hand the moves to `issues` to file, and a
move that turns out to be a misplaced mention to `context review` instead.
