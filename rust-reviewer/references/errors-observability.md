# Errors and Observability

Use this reference for `Result`, custom errors, `panic!`, `unwrap`, `expect`, logging, tracing, diagnostics, and user/operator-facing failures.

## Core Stance

- Use `Result<T, E>` for expected failures. Reserve panics for bugs, violated invariants, impossible states, tests, and process-fatal startup assumptions.
- Error handling should preserve actionability. Add context where the lower-level error is not enough to diagnose the failed operation.
- Library APIs should usually expose typed errors. Application edges can use flexible report-style errors when callers do not need to match variants.
- Do not erase structure too early. Once an error becomes a string, callers cannot inspect it.
- Avoid `unwrap` and `expect` in production paths unless the invariant is local, obvious, and a panic is the desired failure mode.
- Observability belongs at boundaries and important state transitions, not in every small helper.

## Error Types

- Use a dedicated error enum for libraries, reusable crates, and APIs whose callers need to handle cases differently.
- Use `thiserror` or manual `Error` impls according to repo convention for typed errors.
- Use `anyhow` or similar application error types where the main need is propagation with context, not stable matching.
- Include source errors with `#[source]`, `#[from]`, or manual `source()` when preserving cause chains matters.
- Prefer variant names that describe the operation or domain failure, not the implementation detail alone.
- Avoid exposing third-party error types in public APIs unless they are part of the intentional contract.
- Keep error messages stable enough for humans, but do not make callers parse strings.

## Context and Propagation

- Use `?` for straightforward propagation.
- Add context at semantic boundaries: reading config, parsing a specific file, connecting to a named service, applying a migration, decoding a known payload.
- Avoid adding redundant context at every layer.
- Include identifiers that help operators debug: path, table, key, request id, operation name, external system, safe non-secret parameter.
- Do not include secrets, tokens, credentials, raw PII, or large payloads in error messages or logs.
- Convert external errors once at the boundary where the domain meaning is known.

## Panic, Unwrap, and Expect

- `panic!` is acceptable for impossible states, programmer errors, invariant violations, and tests.
- `unwrap` is acceptable in tests and examples when failure would make the test setup invalid. In production, prefer explicit handling or a narrow `expect` message that states the invariant.
- Do not use `unwrap` on external input, network data, file content, environment variables, locks, time, parsing, indexing, or optional config in production paths.
- If a panic crosses FFI, thread, or async task boundaries, consider whether it aborts, unwinds safely, or leaves partial state.
- Indexing with `[]` panics; prefer `get` when absence is possible.

## Logging and Tracing

- Match the repo's logging facade: `tracing`, `log`, framework logging, or no logging.
- In async services, structured spans and fields usually age better than free-form log strings.
- Instrument request, job, task, database, queue, and external-service boundaries with stable identifiers.
- Libraries should emit diagnostics but should not install global subscribers/loggers.
- Avoid holding `tracing::Span::enter` guards across `.await`; use instrumentation helpers/patterns that preserve async context.
- Use levels deliberately: `error` for failed operations needing attention, `warn` for degraded but continuing behavior, `info` for lifecycle milestones, `debug`/`trace` for diagnosis.

## Common Findings

- Production code unwraps fallible external input.
- Error conversion erases a variant callers need to handle.
- Error context omits the path/key/service that would identify the failed operation.
- Error/log includes a secret or sensitive payload.
- Library sets global tracing/logging subscriber.
- Panic is used for an expected runtime condition.
- Error variant exposes a third-party type that should remain internal.
- Async span guard is held across `.await`.
