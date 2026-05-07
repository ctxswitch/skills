# Testing Rust

Use this reference for unit tests, integration tests, doc tests, async tests, property tests, fixtures, mocks/fakes, regression tests, and validation commands.

## Core Stance

- Follow the repo's existing test layout and Cargo scripts.
- Test behavior, invariants, and public contracts before private implementation details.
- Add regression coverage for bug fixes when practical.
- Keep tests deterministic: no real network, wall-clock timing, global mutable state, random seeds, host-specific paths, or test-order assumptions unless explicitly controlled.
- Use the cheapest validation that catches the risk: unit test, integration test, doc test, compile test, property test, benchmark, or targeted `cargo check`.

## Unit and Integration Tests

- Put unit tests near private helpers when testing internal invariants is useful.
- Use integration tests for public crate behavior, CLI behavior, wire formats, storage boundaries, and multi-module flows.
- Prefer clear fixture builders over large opaque blobs.
- Test success, failure, boundary, empty, duplicate, malformed, permission, timeout, cancellation, and concurrency cases when relevant.
- Avoid assertions that duplicate implementation line by line.
- Use temp directories/files for filesystem tests and clean up through RAII helpers.

## Doc Tests and Examples

- Public APIs should have examples where usage is not obvious.
- Doc tests should compile and show realistic usage, not only mechanical invocation.
- Examples should use `?` for fallible code where possible and avoid `unwrap` unless the example is intentionally minimal or setup-only.
- Document panic, error, safety, and feature-gated behavior for public APIs that need it.

## Async and Concurrency Tests

- Use the repo's async test runtime and attributes.
- Avoid arbitrary sleeps. Use channels, barriers, virtual time, timeouts, or explicit synchronization.
- Test cancellation, timeout, task failure, shutdown, and stale-result behavior when the change touches task ownership.
- Do not leave background tasks running past test completion.
- Be careful with single-thread versus multi-thread runtime differences.
- Make tests robust to scheduling order unless order is the behavior under test.

## Property, Fuzz, and Compile Tests

- Use property tests for parsers, serializers, state machines, normalization, round trips, ordering, and invariant-heavy code.
- Use fuzzing for untrusted binary/text parsers and protocol decoders when the project already has fuzz infrastructure or the risk justifies adding it.
- Use compile-fail tests for macros, unsafe APIs, trait contracts, and type-level guarantees when the crate already uses trybuild/compiletest or the API needs it.
- Keep generated random data small enough for fast local runs unless the test is explicitly slow.

## Validation Commands

- `cargo fmt --check` or `cargo fmt` for formatting.
- `cargo check` for fast type and borrow validation.
- `cargo test` for behavior and doc tests.
- `cargo clippy` for idiom and correctness lints.
- `cargo test --all-features` and `--no-default-features` for feature-sensitive crates.
- Package-specific commands are better than whole-workspace commands for narrow edits, unless shared contracts changed.

## Common Findings

- Bug fix lacks a regression test and the behavior can regress silently.
- Test depends on wall-clock sleep or real external service.
- Async test passes while a spawned task can still fail later.
- Test uses `unwrap` in the action under test and hides the failure path.
- Integration behavior is only unit-tested through private helpers.
- Feature-gated API has no enabled/disabled coverage.
- Public API example does not compile or omits important error/panic/safety notes.
- Validation skipped `cargo check` after changing trait bounds or public types.
