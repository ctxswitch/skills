---
name: go-engineer
description: "Implement focused, idiomatic Go changes in existing codebases with a preference for deep modules: narrow, stable interfaces backed by cohesive implementation that hides complexity. Use when the user asks to add, fix, or modify Go code, Go tests, Go services, APIs, concurrency, error handling, package structure, or production behavior while staying tightly scoped to the requested change."
---

# Go Engineer

Write correct, idiomatic Go. Stay in scope, match the repository's existing style, and prefer narrow changes that preserve package boundaries.

## Workflow

1. Verify before use. Read or search definitions before calling repo APIs, using fields, instantiating types, or trusting a helper mentioned in the prompt.
2. Diagnose before fixing. Read the actual error, failing test, or surrounding behavior before editing.
3. Keep edits narrow. Do not refactor, rename, reorganize, or improve unrelated code.
4. Protect repository boundaries. Check generated and ignored paths before editing questionable files.
5. Validate incrementally. Prefer `go test` for affected packages during work. Run `gofmt` on touched Go files. Run broader `go test ./...` or `go vet ./...` when risk or scope justifies it.
6. Stop and ask when correctness depends on an ambiguous product or architecture decision.

## Loading Rule

- Read `references/go-standards.md` before making non-trivial production Go changes, adding packages, changing exported APIs, or touching concurrency/error handling.
- Read `references/testing.md` before adding, changing, or reviewing Go tests.
- Read `references/deep-modules.md` when package boundaries, interfaces, mocks, exported helpers, orchestration, or module shape are involved.
- Read `references/security-performance.md` when handling external input, credentials, SQL, shell commands, HTTP/I/O, cryptography, goroutines, locks, unbounded data, or hot paths.
- For small mechanical edits, load only the specific reference that applies.

## Implementation Stance

- Make the smallest change that solves the requested behavior.
- Prefer existing repo patterns over introducing a new abstraction.
- Add abstractions only when they hide real complexity or match an established local boundary.
- Do not mock code owned by the repo just to make private structure testable.
- Do not edit generated files by hand.
- Run formatting and focused tests before reporting completion.

## Report

When done, report only:

- Files modified and what changed.
- Assumptions worth review.
- Unrelated issues noticed.
- Build, test, vet, and format status.
