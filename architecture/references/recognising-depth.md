# Recognising Depth Problems

Assumes the vocabulary in [language.md](./language.md) — **module**, **interface**, **seam**, **depth**.

Shallow boundaries do not announce themselves. Scan for these.

## Shallow module smells

- Exported helpers that callers must sequence correctly.
- Pass-through package with little behavior.
- Public API nearly as complex as implementation.
- Broad config structs full of implementation knobs.
- Callbacks that leak internal lifecycle.
- Types exported only so another package can complete the module's workflow.
- Package exists only to avoid an import cycle or satisfy a mock.
- Interface abstraction hides where the behavior really belongs.

## Test signals

Tests surface depth problems earlier and more reliably than reading the code does:

- many tests repeat the same orchestration
- setup requires knowledge of internal sequencing
- behavior can only be verified by mocking several repo-owned collaborators
- adding one feature requires edits across many thin wrappers
- tests fail during refactor even though behavior is preserved

## Interface type rules

Written with Go's `interface` in mind; the reasoning holds wherever a language has an explicit abstraction keyword.

- Keep interfaces small and consumer-owned.
- Define an interface where the consumer needs substitutability.
- Do not create an interface type solely to make a shallow module look abstract.
- Do not wrap one method once unless it is a real boundary.
- Do not use interfaces to avoid passing the concrete module that owns behavior.
- Prefer concrete types when the package owns the implementation and callers do not need substitutability.

## Shaping rules

- Add one clear entry point over several thin wrappers when one operation is what callers need.
- Hide sequencing, validation, retries, translation, defaults, and persistence details behind the boundary when they are part of the same responsibility.
- Do not expose internal state, intermediate types, flags, callbacks, or helper functions just because implementation code needs them.
- Split modules when responsibilities are genuinely different, not just to make files or functions smaller.

## Severity

Treat depth issues as `P2` unless they cause a concrete correctness, security, build, or test failure.

Escalate when a shallow boundary causes:

- duplicated validation
- caller-managed retries or persistence
- inconsistent authorization or invariants
- hard-to-test behavior
- import cycles
- unsafe concurrency ownership

## Caution

Do not deepen by creating vague utility packages or generic abstractions. Deepening should make the caller's job simpler and the behavior easier to test through a stable seam. A deepening that produces a `util` package has gone backwards.
