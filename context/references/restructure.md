# Restructure

Propose changes to how the code is organised, from what the recorded hierarchy says about the domain.
The output is moves — collapse this, deepen that, give this concept a home — not observations.

The hierarchy is the only artifact holding the whole domain model at a readable size, which is what makes
this possible over a repository too large to read. It is a summary of what callers rely on, so it can say
where boundaries sit wrongly. It cannot say anything about how the code is built: dead code beyond the
`## Defects` entries, duplicated implementation, performance, coupling at the import level, and test gaps
are all invisible here. A request for those is declined rather than guessed at.

## Deriving the graph

Run [graph.py](../scripts/graph.py) against the root. It resolves every bold mention to the scope that
defines the term and reports divided ownership, unowned vocabulary, fan-in, fan-out, mutual pairs,
concentration, and isolated scopes. Nothing is stored — a recorded map is a second copy of facts each
scope already owns and drifts the moment code changes without it, while a graph recomputed from the files
cannot disagree with them.

Read the normalization collisions first. The graph resolves mentions by matching against terms that exist,
so a miss means a scope spelled a term differently, and every edge downstream of it is wrong.

**The graph is the floor, not the finding set.** It matches names, so it counts what is bolded and nothing
else — a scope referencing a neighbour in plain prose produces no edge, which makes every fan-out a lower
bound. More importantly it cannot see two names for one concept, and that is where the largest moves live.
Read the definitions themselves for those; the graph will not raise them.

## Moves

Each move is named by the signal that raises it. The signal is never the finding — it is where to look.

- **Home** — a term several scopes reference and none defines. The concept is real, and each user is left
  to realise it however it needs. Give it an owning scope, or establish that the scopes mean different
  things by the same word.
- **Extract** — one term defined in two scopes that are neither siblings nor lineal. Two definitions drift
  independently because nothing reads them together. Either one scope owns it and the other depends, or
  the shared meaning belongs in a scope both already depend on.
- **Twin** — two scopes whose terms read as one set with a word substituted through it, so that each
  definition has a counterpart differing only in the axis that separates them. One concept is built twice
  and parameterised by hand. No signal in the graph raises this, because the names differ by construction;
  it is found by reading definitions side by side, and it is usually the largest move available.
- **Deepen** — a scope owning many terms that fall into clusters with little language between them. The
  scope carries several responsibilities under one boundary. Split it along the clusters.
- **Collapse** — a scope whose terms are referenced by exactly one neighbour, or which owns almost no
  language of its own. The directory is a boundary the domain does not have.
- **Re-seam** — two scopes that each reference the other. Neither can change alone, so the split is on the
  wrong axis: either a third concept wants extracting, or the boundary belongs elsewhere.
- **Stabilize** — a scope with high fan-in. Not a split — every other scope changing around it is what a
  shared foundation looks like. The move is an explicit contract, so the coupling runs through something
  named rather than through whatever is reachable.

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

**An unverified move is labelled as one.** The graph shows what the files say, which is a claim about code
and not evidence of it. Every move below the verified cut is reported as a candidate with the check that
would settle it.

The common false positive is a scope that documents a neighbour's vocabulary instead of referencing it.
That inflates fan-out, and two scopes doing it to each other manufacture a Re-seam out of nothing. It is a
placement defect for a review to repair, not a code change. Check it first — it is the cheapest to rule
out and the most likely.

What settles each move:

- **Home** — whether a scope already implements the concept without recording it. If one does, the move is
  to record it there; only if none does is there something to build.
- **Extract** — whether both scopes implement the concept, or one implements and the other describes.
- **Twin** — whether the two implementations share structure, or the parallel language describes
  mechanisms that only sound alike. Parallel vocabulary is cheap to write and proves nothing on its own.
- **Deepen** — whether the clusters correspond to separable files, or to one tangled unit.
- **Collapse** — whether anything outside the neighbouring scope depends on it.
- **Re-seam** — whether the code crosses both ways, or only the language does.
- **Stabilize** — whether consumers reach through a named interface or into internals.

## Tracking

Track under `.claude/context/<session>/` like the other modes. A restructure writes `moves.md` and no
per-scope records — its subject is the graph over the hierarchy, not any one scope.

```md
# Restructure: {root scope}

| Move | Scopes | Radius | Verified |
| ---- | ------ | ------ | -------- |
| Home: **Run** | 3 | 3 | x |
| Extract: **Action Token** | 2 | 2 | |
```

## Reporting

Report the graph's shape first — scopes, terms, edges — then every move in rank order, each carrying the
signal that raised it, the scopes it touches, the proposed change, and either what verification found or
the check still outstanding.

Nothing is written to a `.context.md` and no source is changed. Hand the moves to `issues` to file, and a
move that turns out to be a misplaced mention to `context review` instead.
