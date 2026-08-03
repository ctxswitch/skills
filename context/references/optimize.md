# Optimize

Propose changes that make the codebase more maintainable, read out of the recorded domain model. The
output is moves — collapse this, deepen that, stabilize this seam, remove the compensation this boundary
forces — not observations.

A repository's recorded language is a small fraction of the source it describes, so the whole domain model
fits in one context where the code never will. That is what makes this possible on a monorepo, and it is
the only thing that does. Read the hierarchy; do not measure over it. Every move here is a judgement about
what two entries mean, and matching term names answers a different question.

It cannot see how the code is built: dead code beyond recorded `## Defects`, duplicated implementation,
performance, import cycles, test gaps. A request for those is declined rather than guessed at.

## Reading

Read every `.context.md` beneath the root, and read the whole file — the moves below come out of
`## Relationships`, `## Decisions`, `## Flagged ambiguities`, and the `_Avoid_`, `_Fixed_`, and
`_Pending_` markers at least as often as out of a definition.

Hold the entries of scopes that exchange a domain object side by side. A pass that summarises each file
alone finds nothing, because every move is one entry read against another.

## Moves

### Simplify — complexity the structure forces

- **Absorb** — a relationship recording compensation: a best-effort drain with no requeue, a retry until
  cancelled, an idempotent re-report, a value written early so a later retry still carries it. Each names
  work the code does to survive a boundary. The move is the boundary; the compensation is the symptom.
- **Twin** — two scopes whose terms read as one set with a word substituted through it, each definition
  having a counterpart differing only in the axis that separates them. One concept built twice and
  parameterised by hand. Usually the largest move available.
- **Centralize** — one constraint restated as `_Fixed_` or a `## Decisions` line at several scopes. A rule
  maintained by hand in N places drifts in N places.

### Organize — language that sits in the wrong place

- **Home** — a term several scopes use and none defines. Each user realises the concept however it needs.
  Give it an owning scope, or establish that the scopes mean different things by one word.
- **Facet** — one name carrying both a representation and the behaviour it represents, in two scopes. Both
  are real, so neither goes; the representation side takes a suffix naming what it is. Where the hierarchy
  already has such a convention, the finding is which terms break it.
- **Writer** — a relationship naming a sole writer for some state, where another scope's entries show it
  writing the same thing. Either the boundary is wrong or the claim is.
- **Rename** — a term carrying a long `_Avoid_` list. People keep reaching for other words because the
  name is wrong or the concept is. Read the avoided words: if they name one thing, rename; if they name
  several, the term is doing too much.

### Reshape — boundaries in the wrong position

- **Seam** — two scopes whose entries each depend on the other's language, so neither changes alone. The
  split is on the wrong axis: either a third concept wants extracting, or the boundary belongs elsewhere.
- **Stabilize** — a scope most others reach into. Not a split — a shared foundation is supposed to be
  depended on. The move is an explicit contract, so the coupling runs through something named rather than
  through whatever is reachable, and the foundation can change behind it.
- **Deepen** — a scope owning many terms that fall into clusters with little language between them. It
  carries several responsibilities under one boundary. Split along the clusters.
- **Collapse** — a scope whose language is referenced by exactly one neighbour, or which owns almost none
  of its own. The directory is a boundary the domain does not have.

### Settle — decisions the codebase is paying to defer

- **Settle** — an unresolved `## Flagged ambiguities` entry spanning two scopes. Every reader pays for it
  and no code closes it. The move is the decision, not a rewrite.
- **Land or drop** — a `_Pending_:` term whose code never arrived. Either it is next, or the language
  should go before someone builds against it.

**Collapse and Deepen propose changes to code, never to where language is recorded.** The sweep's rule
stands: a scope holding source gets a file, and folding its language into a parent to avoid creating one
is the mirror failure. These propose that directories should merge or split, after which a sweep records
whatever shape results. Never resolve one by deleting a context file.

## Ranking

Rank by blast radius — how many scopes the move touches, then how much language moves with it. Report the
ranking before verifying anything, so the choice of what got checked is visible.

## Verifying

Take the highest-ranked moves and open the source each names — three to five — and say how many were
verified and how many were not.

**An unverified move is labelled as one.** A context file records what someone wrote about the code, which
is a claim and not evidence. Every move below the cut is a candidate carrying the check that would settle
it.

The common false positive is a scope that documents a neighbour's vocabulary rather than owning it, which
reads as shared language where there is only a copy — and two scopes doing it to each other manufacture a
Seam out of nothing. That is a placement defect for a review, not a code change. Rule it out first: it is
the cheapest check and the most likely explanation.

What settles each move:

- **Absorb** — whether the compensation is inherent to the domain or an artifact of where the boundary sits.
- **Twin** — whether the two implementations share structure, or the parallel language describes mechanisms
  that only sound alike. Parallel vocabulary is cheap to write and proves nothing.
- **Centralize** — whether the restatements are one rule or several that happen to read alike.
- **Home** — whether a scope already implements the concept without recording it. If one does, the move is
  to record it there; only if none does is there something to build.
- **Facet** — whether the two definitions describe one thing at different levels or two things that
  collided on a name. Only the first is a rename.
- **Writer** — which scope actually writes the state.
- **Rename** — whether the avoided words name one concept or several.
- **Seam** — whether the code crosses both ways, or only the language does.
- **Stabilize** — whether consumers reach through a named interface or into internals.
- **Deepen** — whether the clusters correspond to separable files, or to one tangled unit.
- **Collapse** — whether anything outside the neighbouring scope depends on it.
- **Settle** / **Land or drop** — these need the maintainer, not the source. Carry them to the report as
  questions.

## Tracking

Track under `.claude/context/<session>/` like the other modes. An optimize run writes `moves.md`, appending
each move as it is raised and each scope to `## Read` as it is read — the reading is the expensive part,
and a move raised but unwritten is lost with the context that held it.

```md
# Optimize: {root scope}

| Move | Scopes | Radius | Verified |
| ---- | ------ | ------ | -------- |
| Twin: secret / variable | 4 | 12 | x |
| Stabilize: `services/agent` | 13 | 14 | |

## Read

- `internal/order` — 8 terms, nothing raised
```

A scope read and raising nothing is recorded saying so, or a resumed run cannot tell it from one never
opened.

## Reporting

Report how many scopes were read and how many raised nothing, then every move in rank order, each carrying
what raised it, the scopes it touches, the proposed change, and either what verification found or the check
still outstanding.

Nothing is written to a `.context.md` and no source is changed. Hand the moves to `issues` to file, and a
move that turns out to be a misplaced entry to `context review` instead.
