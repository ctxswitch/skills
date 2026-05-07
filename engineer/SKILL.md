---
name: engineer
description: "Use when asked to implement, build, add, fix, modify, debug, refactor, or test production code across Go, Python, Rust, or TypeScript/React/Tailwind. Covers services, APIs, CLIs, packages/crates, tests, async/concurrency, errors, ownership/borrowing, typing, packaging/Cargo, hooks, TSX/JSX, Tailwind styling, tooling, security, performance, and multi-language contracts."
---

# Engineer

Write correct, idiomatic code. Stay in scope, match the repository's existing style, and route to the language-specific references only for the languages and contracts touched by the change.

## Workflow

1. Verify before use. Read or search definitions before calling repo APIs, importing helpers, assuming types/fields/props, relying on feature flags, or trusting a helper mentioned in the prompt.
2. Diagnose before fixing. Read the actual error, failing test, traceback, compiler output, type-check output, runtime warning, panic, or surrounding behavior before editing.
3. Identify touched languages and contract boundaries before editing.
4. Keep edits narrow. Do not refactor, rename, reorganize, restyle, change public APIs, alter dependency graphs, or improve unrelated code unless the requested behavior requires it.
5. Protect repository boundaries. Check generated files, vendored files, lock files, ignored paths, package/crate/module ownership, route conventions, public exports, and feature flags before editing.
6. Validate incrementally with the repo's existing tooling for each affected language/package.
7. Stop and ask when correctness depends on an ambiguous product, API, data-model, design, semver, unsafe invariant, accessibility, runtime, feature-flag, performance, or compatibility decision.

## Language Routing

- Go: read the relevant files under `references/go/`.
- Python: read the relevant files under `references/python/`.
- Rust: read the relevant files under `references/rust/`.
- TypeScript, React, or Tailwind: read the relevant files under `references/typescript/`.
- Mixed-language changes: read `references/cross-language/contracts.md` plus only the touched language references.

Load references incrementally. Prefer the most specific file for the changed code.

## Reference Map

- Go: `references/go/go-standards.md`, `testing.md`, `deep-modules.md`, `security-performance.md`.
- Python: `references/python/python-standards.md`, `typing-and-api-design.md`, `testing.md`, `packaging-tooling.md`, `async-and-resources.md`, `security-performance.md`.
- Rust: `references/rust/rust-standards.md`, `errors-observability.md`, `async-concurrency.md`, `cargo-tooling.md`, `testing.md`, `unsafe-security-performance.md`.
- TypeScript/React/Tailwind: `references/typescript/typescript-standards.md`, `react-components-hooks.md`, `tailwind-ui.md`, `testing.md`, `tooling-config.md`, `security-performance-accessibility.md`.
- Cross-language: `references/cross-language/contracts.md`.

## Implementation Stance

- Make the smallest change that solves the requested behavior.
- Prefer existing repo patterns, component libraries, package/crate/module boundaries, dependency strategy, async runtime, CSS strategy, error strategy, and validation scripts.
- Add abstractions only when they hide real complexity, encode a real invariant, or match an established local boundary.
- Preserve supported language/runtime versions, public API compatibility, dependency constraints, feature behavior, accessibility expectations, and production behavior.
- Do not mock code owned by the repo just to make private structure testable.
- Do not hand-edit generated files.
- Run focused validation before reporting completion.

## Report

When done, report only:

- Files modified and what changed.
- Assumptions worth review.
- Unrelated issues noticed.
- Test, type-check, lint, format, build, vet, clippy, doc-test, browser-check, benchmark, or package validation status when relevant.
