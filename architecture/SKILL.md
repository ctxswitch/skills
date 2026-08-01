---
name: architecture
description: "Survey a codebase for shallow modules and propose deepening refactors, then design the replacement interface with the user. Use when improving structure is the task itself — not when a requested change happens to involve some refactoring."
---

# Architecture

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones. The aim is testability and navigability.

## Right-size first (read before proposing anything)

The default failure mode of this skill is **proposing abstraction**: adding a layer, extracting an interface, introducing a helper, splitting a file. Most of those make modules shallower, not deeper. Guard against it:

- **Prefer merging and deleting over adding.** The most common correct deepening is fewer modules, not more. If a proposal's net effect is more files, more indirection, or more names to learn, say why the leverage is worth it.
- **Apply the deletion test before proposing anything.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep. A candidate that fails this test is not a finding.
- **One adapter is a hypothetical seam.** Do not propose a port, interface, or injection point that will have exactly one implementation. The test adapter is what makes the second one real.
- **Extracting for testability is not deepening.** Pulling a pure function out so it can be unit-tested, while the real bugs live in how it is called, moves the code without moving the risk.
- **Friction you cannot name is not friction.** Every candidate needs a concrete cost someone is paying now — duplicated validation, a bug class that recurs, a test that cannot be written. "This could be cleaner" is not a candidate.

This skill's output is claims about how code relates to other code, so two more apply:

- **Do not manufacture links.** Before asserting that two modules are coupled, that a candidate contradicts an ADR, or that one change forces another, name the concrete case where it holds. Shared vocabulary is not coupling — two modules can use the same words and never interact. Sharing a filename is not sharing a purpose. If you cannot name the case, it is not a finding.
- **Verify specifics before asserting them.** Callers, import graphs, who owns which type, what a test actually exercises, what an ADR actually says — read them. A deepening proposal built on a remembered call graph is a proposal to break something.

## Glossary

Use these terms exactly in every suggestion — don't drift into "component," "service," "API," or "boundary." Full definitions in [language.md](./references/language.md).

- **Module** — anything with an interface and an implementation (function, class, package, slice).
- **Interface** — everything a caller must know: types, invariants, error modes, ordering, config. Not just the type signature.
- **Implementation** — the code inside.
- **Depth** — leverage at the interface. **Deep** = a lot of behaviour behind a small interface. **Shallow** = interface nearly as complex as the implementation.
- **Seam** — where an interface lives; a place behaviour can be altered without editing in place. (Use this, not "boundary.")
- **Adapter** — a concrete thing satisfying an interface at a seam.
- **Leverage** — what callers get from depth.
- **Locality** — what maintainers get from depth: change, bugs, knowledge concentrated in one place.

This skill is _informed_ by the project's domain model. The domain language gives names to good seams; ADRs record decisions the skill should not re-litigate.

## Process

### 1. Explore

Read the project's domain glossary and any ADRs in the area first.

Then walk the codebase. Explore organically rather than following rigid heuristics, and note where you experience friction. Read [recognising-depth.md](./references/recognising-depth.md) before judging — it lists the concrete smells and the test signals that expose them.

- Where does understanding one concept require bouncing between many small modules?
- Where are modules **shallow** — interface nearly as complex as the implementation?
- Where have pure functions been extracted just for testability, but the real bugs hide in how they're called (no **locality**)?
- Where do tightly-coupled modules leak across their seams?
- Which parts are untested, or hard to test through their current interface?

### 2. Present candidates

Present a numbered list. For each candidate:

- **Files** — which files/modules are involved
- **Problem** — the concrete cost being paid now
- **Solution** — plain English description of what would change
- **Benefits** — in terms of locality and leverage, and how tests would improve

**Use `CONTEXT.md` vocabulary for the domain and the glossary above for the architecture.** If `CONTEXT.md` defines "Order," talk about "the Order intake module" — not "the FooBarHandler," and not "the Order service."

**ADR conflicts**: if a candidate contradicts an existing ADR, only surface it when the friction is real enough to warrant revisiting the ADR. Mark it clearly (e.g. _"contradicts ADR-0007 — but worth reopening because…"_). Don't list every theoretical refactor an ADR forbids.

Do NOT propose interfaces yet. Ask the user which they'd like to explore.

### 3. Grilling loop

Once the user picks a candidate, drop into a grilling conversation. Walk the design tree with them — constraints, dependencies, the shape of the deepened module, what sits behind the seam, what tests survive. [deepening.md](./references/deepening.md) covers dependency categories and testing strategy; [testability.md](./references/testability.md) covers interfaces that make behaviour hard to observe.

Side effects happen inline as decisions crystallize:

- **Naming a deepened module after a concept not in `CONTEXT.md`?** Add the term to `CONTEXT.md` right there, using the same discipline and format as the `grill-me` skill. Create the file lazily if it doesn't exist.
- **Sharpening a fuzzy term during the conversation?** Update `CONTEXT.md` right there.
- **User rejects the candidate with a load-bearing reason?** Offer an ADR, framed as: _"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_ Only offer when the reason would actually be needed by a future explorer to avoid re-suggesting the same thing — skip ephemeral reasons ("not worth it right now") and self-evident ones. Use the ADR format from the `grill-me` skill.
- **Want to explore alternative interfaces?** See [interface-design.md](./references/interface-design.md).

## Reference map

- [language.md](./references/language.md) — vocabulary, principles, relationships, rejected framings.
- [recognising-depth.md](./references/recognising-depth.md) — shallow-module smells, test signals, interface type rules, severity.
- [deepening.md](./references/deepening.md) — dependency categories, seam discipline, testing strategy.
- [testability.md](./references/testability.md) — designing interfaces that expose outcomes.
- [interface-design.md](./references/interface-design.md) — "design it twice" exploration of alternative interfaces.
