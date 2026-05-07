# Deep Modules In TDD

Use this when tests reveal scattered complexity or shallow interfaces.

## Concept

A deep module has a small interface with substantial implementation hidden behind it. It gives callers leverage.

A shallow module has an interface nearly as complex as its implementation. It often forces callers and tests to know too much.

## TDD Signal

Tests often reveal module depth problems:

- many tests repeat the same orchestration
- setup requires knowledge of internal sequencing
- behavior can only be verified by mocking several repo-owned collaborators
- adding one feature requires edits across many thin wrappers
- tests fail during refactor even though behavior is preserved

## Deepening Moves

Consider:

- combine thin pass-through layers into one meaningful operation
- move sequencing behind the public interface
- hide validation, defaults, retries, translation, and persistence details when they belong to the same responsibility
- expose one cohesive command instead of many tiny steps
- make derived state rebuildable behind a clear owner

## Caution

Do not deepen by creating vague utility packages or generic abstractions. Deepening should make the caller's job simpler and the behavior easier to test through a stable seam.
