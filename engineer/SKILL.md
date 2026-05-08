---
name: engineer
description: "Use when asked to plan, implement, build, add, fix, modify, debug, refactor, or test production code across Go, Python, Rust, TypeScript/React/Tailwind, or Protocol Buffers. Covers implementation-ready plans, services, APIs, CLIs, packages/crates, .proto schemas, gRPC/ConnectRPC, tests, async/concurrency, errors, ownership/borrowing, typing, packaging/Cargo, hooks, TSX/JSX, Tailwind styling, tooling, security, performance, and multi-language contracts."
---

# Engineer

Write correct, idiomatic code. Stay in scope, match the repository's existing style, and route to the language-specific references only for the languages and contracts touched by the change.

## Workflow

1. Verify before use. Read or search definitions before calling repo APIs, importing helpers, assuming types/fields/props, relying on feature flags, or trusting a helper mentioned in the prompt.
2. Diagnose before fixing. Read the actual error, failing test, traceback, compiler output, type-check output, runtime warning, panic, or surrounding behavior before editing.
3. Identify touched languages and contract boundaries before editing.
4. Look for local deepening opportunities in the touched area: shallow modules, pass-through interfaces, duplicated orchestration, leaky seams, tests that reach past the interface, or complexity spread across callers.
5. Keep edits narrow. Do not refactor, rename, reorganize, restyle, change public APIs, alter dependency graphs, or improve unrelated code unless the requested behavior requires it.
6. Protect repository boundaries. Check generated files, vendored files, lock files, ignored paths, package/crate/module ownership, route conventions, public exports, and feature flags before editing.
7. Validate incrementally with the repo's existing tooling for each affected language/package.
8. Stop and ask when correctness depends on an ambiguous product, API, data-model, design, semver, unsafe invariant, accessibility, runtime, feature-flag, performance, or compatibility decision.

## Language Routing

- Go: read the relevant files under `references/go/`.
- Python: read the relevant files under `references/python/`.
- Rust: read the relevant files under `references/rust/`.
- TypeScript, React, or Tailwind: read the relevant files under `references/typescript/`.
- Protocol Buffers, gRPC, or ConnectRPC: read the relevant files under `references/proto/`.
- Mixed-language changes: read `references/cross-language/contracts.md` plus only the touched language references.
- Deepening opportunities: read `references/architecture/language.md` and `references/architecture/deepening.md` when the touched code shows shallow modules, awkward seams, duplicated orchestration, caller-spread complexity, or tests that need private implementation details.

Load references incrementally. Prefer the most specific file for the changed code.

## Reference Map

- Go: `references/go/go-standards.md`, `testing.md`, `deep-modules.md`, `security-performance.md`.
- Python: `references/python/python-standards.md`, `typing-and-api-design.md`, `testing.md`, `packaging-tooling.md`, `async-and-resources.md`, `security-performance.md`.
- Rust: `references/rust/rust-standards.md`, `errors-observability.md`, `async-concurrency.md`, `cargo-tooling.md`, `testing.md`, `unsafe-security-performance.md`.
- TypeScript/React/Tailwind: `references/typescript/typescript-standards.md`, `react-components-hooks.md`, `tailwind-ui.md`, `testing.md`, `tooling-config.md`, `security-performance-accessibility.md`.
- Protocol Buffers/gRPC/ConnectRPC: `references/proto/schema-design.md`, `compatibility.md`, `services-generation.md`, `connectrpc.md`, `tooling-validation.md`.
- Cross-language: `references/cross-language/contracts.md`.
- Architecture: `references/architecture/language.md`, `deepening.md`.

## Deepening Check

Always consider whether the touched code can become deeper without expanding the task. Use the `improve-codebase-architecture` vocabulary: a module should hide meaningful behavior behind a small interface, concentrate locality, and give callers leverage.

- Apply the deletion test: if deleting a module makes complexity vanish, it is probably pass-through; if complexity reappears across callers, it is earning its keep.
- Prefer tests through the module interface. If tests need private structure, the interface or seam may be wrong.
- Do not introduce a seam for one adapter. One adapter is hypothetical; two adapters make a seam real.
- If a deepening is small, local, and directly supports the requested change, include it.
- If a deepening is larger than the requested change, preserve the narrow fix and report the opportunity with the files, problem, and likely shape.

## Planning Mode

When asked to plan implementation work, produce a plan detailed enough for the next engineer to execute without rediscovering the same context.

Include:

- Touched files, modules, packages/crates, routes, generated outputs, schemas, and contract boundaries to inspect or change.
- The sequence of edits, including dependency order across languages or generated code.
- The interface, seam, adapter, or module shape if the plan creates or deepens a module.
- Compatibility, migration, rollout, feature-flag, accessibility, security, and performance concerns that affect implementation.
- Tests and validation commands for each affected language/package.
- Open decisions that must be resolved before coding.

Do not stop at high-level phases like "update backend" or "add tests." Name the concrete code surfaces and validation path. If a plan is likely to fail because the codebase shape is unknown, inspect first.

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
