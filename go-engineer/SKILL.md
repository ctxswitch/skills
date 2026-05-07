---
name: go-engineer
description: "Implement focused, idiomatic Go changes in existing codebases with a preference for deep modules: narrow, stable interfaces backed by cohesive implementation that hides complexity. Use when Codex is asked to add, fix, or modify Go code, Go tests, Go services, APIs, concurrency, error handling, package structure, or production behavior while staying tightly scoped to the requested change."
---

# Go Engineer

Write correct, idiomatic Go. Stay in scope and match the repository's existing style.

## Workflow

1. Verify before use. Read or search definitions before calling repo APIs, using fields, instantiating types, or trusting a helper mentioned in the prompt.
2. Diagnose before fixing. Read the actual error, failing test, or surrounding behavior before editing.
3. Keep edits narrow. Do not refactor, rename, reorganize, or improve unrelated code.
4. Protect repository boundaries. Do not edit generated files such as `*.pb.go`, `gen/`, or auto-generated code. Regenerate from source when needed. Check ignored paths before adding or editing questionable files.
5. Validate incrementally. Prefer `go test` for affected packages during work. Run `gofmt` on touched Go files. Run broader `go test ./...` or `go vet ./...` when risk or scope justifies it.
6. Stop and ask when correctness depends on an ambiguous product or architecture decision.

## Go Standards

- Prefer the standard library. Add a dependency only when it clearly reduces complexity, improves maintainability, or raises quality.
- Follow existing package layout. Do not create `util`, `common`, `misc`, `api`, `types`, `interfaces`, or `helpers` packages.
- Export only what external callers need. Add doc comments for exported declarations.
- Keep functions focused. Split mixed concerns. Do not add one-use helpers just to move code around.
- Accept interfaces and return concrete types. Define interfaces at the consumer only when that consumer truly owns a reusable dependency boundary; do not introduce a single-use interface to move orchestration across package boundaries or avoid passing the concrete module that owns the behavior. Do not mock code you own.
- Use `any` in new code, not `interface{}`. Never pass `*SomeInterface`.
- Keep receiver names short and consistent. Do not mix pointer and value receivers without a reason.
- Pass `context.Context` as the first parameter for I/O or cancellable work. Never store it on a struct.
- Handle every error. Wrap useful context with `%w`. Use `errors.Is` and `errors.As`, not string comparisons.
- Avoid panic, `log.Fatal`, and `os.Exit` outside `main` or startup paths.
- Keep control flow flat with guard clauses. Avoid `else` after `return`, `break`, `continue`, or `goto`.
- Prefer nil slices unless JSON or API behavior requires `[]`.
- Use keyed literals for structs from other packages.
- Every goroutine needs an obvious exit path. Prefer synchronous APIs and let callers add concurrency.
- Do not hold locks across I/O, channel sends, or external calls. Use `errgroup.Group` when goroutines can fail.

## Module Design

Prefer deep modules: a small, stable interface with enough internal implementation to hide complexity from callers. Here, "interface" means the module boundary: exported functions, methods, types, config structs, package APIs, and call contracts. It does not always mean a Go `interface` type.

- Keep the public surface narrow. Add one clear entry point over several thin wrappers when one operation is what callers need.
- Hide sequencing, validation, retries, translation, defaults, and persistence details behind the boundary when they are part of the same responsibility.
- Do not expose internal state, intermediate types, flags, callbacks, or helper functions just because implementation code needs them.
- Avoid pass-through packages or methods whose interface is nearly as complex as their implementation.
- Prefer cohesive modules that own a complete responsibility over shallow layers that force callers to coordinate steps.
- Split modules when responsibilities are genuinely different, not just to make files or functions smaller.
- Keep Go interfaces small and consumer-owned, but do not create a Go interface type solely to make a shallow module look abstract, to wrap one method once, or to hide that behavior belongs in a higher orchestration layer.

## Tests

- Add or update tests for behavior changes, bug fixes, exported functions, non-trivial branches, and error paths.
- For bug fixes, write the reproducing test first when practical.
- Use the package's existing test framework. Do not mix assertion styles in one package. For new packages, testify is acceptable.
- Use table-driven tests when scenarios vary by input, expected output, boundary, or error path. Each case needs a `name` and `t.Run`.
- Do not force unrelated scenarios into one table. Split genuinely different subjects.
- Avoid nondeterminism: no arbitrary `time.Sleep`, real network, wall clock dependence, global state leaks, or unseeded randomness.
- Prefer real dependencies, `httptest`, `t.TempDir`, embedded databases, or small in-memory fakes. Mock only external boundaries or hard-to-trigger errors.
- Mark helpers with `t.Helper()`. Failure messages should include inputs, got, and want.

## Security And Performance

- No hardcoded secrets. Read credentials from configuration, environment, or a secret store.
- Validate external input at boundaries.
- Use `subtle.ConstantTimeCompare` for secrets and tokens.
- Use `crypto/rand` for keys, tokens, nonces, salts, and session IDs.
- Give HTTP clients and I/O operations timeouts or deadlines.
- Parameterize SQL. Use `exec.Command(name, args...)`, not shell strings.
- Bound collections that grow with input. Use maps for membership and `strings.Builder` for loop concatenation.

## Report

When done, report only:

- Files modified and what changed.
- Assumptions worth review.
- Unrelated issues noticed.
- Build, test, vet, and format status.
