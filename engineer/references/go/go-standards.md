# Go Standards

Use this for both implementing and reviewing Go code.

## Core Rules

- Prefer the standard library. Add a dependency only when it clearly reduces complexity, improves maintainability, or raises quality.
- Follow existing package layout. Do not create `util`, `common`, `misc`, `api`, `types`, `interfaces`, or `helpers` packages.
- Export only what external callers need. Add doc comments for exported declarations.
- Keep functions focused. Split mixed concerns. Do not add one-use helpers just to move code around.
- Use `any` in new code, not `interface{}`. Never pass `*SomeInterface`.
- Keep receiver names short and consistent. Do not mix pointer and value receivers without a reason.
- Pass `context.Context` as the first parameter for I/O or cancellable work. Never store it on a struct.
- Handle every error. Wrap useful context with `%w`. Use `errors.Is` and `errors.As`, not string comparisons.
- Avoid panic, `log.Fatal`, and `os.Exit` outside `main` or startup paths.
- Keep control flow flat with guard clauses. Avoid `else` after `return`, `break`, `continue`, or `goto`.
- Prefer nil slices unless JSON or API behavior requires `[]`.
- Use keyed literals for structs from other packages.
- Keep business logic out of `cmd/`; `cmd/` should wire and call.

## Interfaces

- Accept interfaces and return concrete types.
- Define interfaces at the consumer only when that consumer truly owns a reusable dependency boundary.
- Do not introduce a single-use interface to move orchestration across package boundaries or avoid passing the concrete module that owns the behavior.
- Do not mock code owned by the repo just to expose private structure.
- Do not return interfaces when a concrete type gives callers a clearer contract.
- One-method interfaces that do not use the `-er` suffix are not a problem by themselves.

## Concurrency

- Every goroutine needs an obvious exit path.
- Prefer synchronous APIs and let callers add concurrency.
- Do not hold locks across I/O, channel sends, or external calls.
- Avoid goroutines in `init`.
- Bound goroutine fan-out.
- Use `errgroup.Group` when goroutines can fail.
- Make cancellation explicit with context for long-running or I/O work.

## Error Handling

- Error messages should include useful operation context.
- Use `%w` when callers may need to unwrap.
- Use sentinel errors sparingly and only when callers branch on them.
- Avoid string comparisons on errors.
- Avoid returning concrete error types from exported APIs unless that type is a stable part of the contract.

## Packages and Names

- Avoid exports repeating package names.
- Avoid `Get` prefixes unless needed for interface compatibility.
- Preserve Go initialism casing.
- Prefer names that explain domain responsibility over implementation shape.
- Do not reorganize packages unless the task requires it.

## Generated and Ignored Files

- Do not edit generated files such as `*.pb.go`, `gen/`, or auto-generated code by hand.
- Regenerate from source when generated files must change.
- Check ignored paths before adding or editing questionable files.
- Do not force-add ignored files unless explicitly requested.
