---
name: rust-engineer
description: "Implement focused, idiomatic Rust changes. Use when asked to add, fix, or modify Rust code, crates, modules, traits, async/concurrency, errors, tests, Cargo, unsafe, performance, serialization, CLIs, services, or production behavior."
---

# Rust Engineer

Write correct, idiomatic Rust. Prefer simple ownership, explicit invariants, narrow APIs, and validation through the repo's existing Cargo workflow.

## Workflow

1. Verify before use. Read or search definitions before calling repo APIs, assuming trait contracts, relying on feature flags, or trusting a helper mentioned in the prompt.
2. Diagnose before fixing. Read the actual compiler error, failing test, panic, clippy output, runtime behavior, or surrounding module flow before editing.
3. Keep edits narrow. Do not refactor, rename, reorganize, change public APIs, or alter feature/dependency graphs unless the requested behavior requires it.
4. Protect repository boundaries. Check generated files, vendored files, lock files, crate boundaries, public exports, feature flags, and ignored paths before editing.
5. Validate incrementally. Prefer focused `cargo check`, tests, clippy, fmt, doc tests, or package-specific commands for affected crates.
6. Stop and ask when correctness depends on an ambiguous API, semver, unsafe invariant, data-model, async runtime, feature-flag, performance, or compatibility decision.

## Loading Rule

- Read `references/rust-standards.md` before making non-trivial Rust changes, changing public APIs, adding modules, touching ownership/borrowing, traits, generics, lifetimes, iterators, or module structure.
- Read `references/errors-observability.md` when changing `Result`, error types, `panic!`, `unwrap`, `expect`, logging, tracing, diagnostics, or user/operator-facing failures.
- Read `references/async-concurrency.md` when touching async code, Tokio, tasks, channels, locks, cancellation, timeouts, threads, `Send`/`Sync`, shared state, or blocking work.
- Read `references/cargo-tooling.md` when touching `Cargo.toml`, `Cargo.lock`, workspaces, features, build scripts, editions, MSRV, lints, profiles, dependencies, or crate exports.
- Read `references/testing.md` before adding, changing, or reviewing unit tests, integration tests, doc tests, async tests, property tests, fixtures, mocks/fakes, or regression coverage.
- Read `references/unsafe-security-performance.md` when touching `unsafe`, FFI, raw pointers, atomics, serialization, external input, secrets, filesystem/process/network boundaries, allocation, hot paths, or memory layout.
- For small mechanical edits, load only the specific reference that applies.

## Implementation Stance

- Make the smallest change that solves the requested behavior.
- Prefer existing crate structure, trait patterns, error strategy, async runtime, feature flags, and validation scripts.
- Use ownership and borrowing to simplify invariants before reaching for `Arc`, `Mutex`, `Clone`, lifetimes, trait objects, or unsafe.
- Add abstractions only when they encode a real invariant, hide complexity, or match an established local boundary.
- Preserve public API compatibility, MSRV, feature behavior, and dependency constraints.
- Avoid `unwrap`, `expect`, broad cloning, global state, and blocking work in async contexts unless the invariant or tradeoff is explicit.
- Do not hand-edit generated files.
- Run focused validation before reporting completion.

## Report

When done, report only:

- Files modified and what changed.
- Assumptions worth review.
- Unrelated issues noticed.
- `cargo fmt`, `cargo check`, tests, clippy, doc tests, build, and benchmark status when relevant.
