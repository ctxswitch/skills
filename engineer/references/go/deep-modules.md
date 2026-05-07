# Deep Modules

Use this for Go package/API design and review.

## Definition

A deep module has a small, stable interface backed by enough implementation to hide complexity from callers.

In this context, "interface" means the module boundary: exported functions, methods, types, config structs, package APIs, and call contracts. It does not always mean a Go `interface` type.

## Design Rules

- Keep the public surface narrow.
- Add one clear entry point over several thin wrappers when one operation is what callers need.
- Hide sequencing, validation, retries, translation, defaults, and persistence details behind the boundary when they are part of the same responsibility.
- Do not expose internal state, intermediate types, flags, callbacks, or helper functions just because implementation code needs them.
- Prefer cohesive modules that own a complete responsibility over shallow layers that force callers to coordinate steps.
- Split modules when responsibilities are genuinely different, not just to make files or functions smaller.

## Shallow Module Smells

- Exported helpers that callers must sequence correctly.
- Pass-through package with little behavior.
- Public API nearly as complex as implementation.
- Broad config structs full of implementation knobs.
- Callbacks that leak internal lifecycle.
- Types exported only so another package can complete the module's workflow.
- Package exists only to avoid an import cycle or satisfy a mock.
- Interface abstraction hides where the behavior really belongs.

## Interface Type Rules

- Keep Go interfaces small and consumer-owned.
- Define an interface where the consumer needs substitutability.
- Do not create a Go interface type solely to make a shallow module look abstract.
- Do not wrap one method once unless it is a real boundary.
- Do not use interfaces to avoid passing the concrete module that owns behavior.
- Prefer concrete types when the package owns the implementation and callers do not need substitutability.

## Review Severity

Treat deep-module issues as `P2` unless they cause a concrete correctness, security, build, or test failure.

Escalate when a shallow boundary causes:

- duplicated validation
- caller-managed retries or persistence
- inconsistent authorization or invariants
- hard-to-test behavior
- import cycles
- unsafe concurrency ownership

## Refactoring Direction

When deepening a module:

1. Identify the caller workflow being manually coordinated.
2. Move the sequencing behind one entry point.
3. Keep data ownership in the module that enforces invariants.
4. Reduce exported intermediate types.
5. Add behavior tests through the new boundary.
6. Preserve existing package style and avoid broad unrelated moves.
