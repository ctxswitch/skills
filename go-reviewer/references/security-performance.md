# Security and Performance

Use this for Go security, resource, and performance checks.

## Security Rules

- No hardcoded secrets. Read credentials from configuration, environment, or a secret store.
- Validate external input at boundaries.
- Parameterize SQL.
- Use `exec.Command(name, args...)`, not shell strings.
- Use `subtle.ConstantTimeCompare` for secrets and tokens.
- Use `crypto/rand` for keys, tokens, nonces, salts, and session IDs.
- Do not disable TLS verification outside test-only code with explicit guardrails.
- Give production HTTP clients and I/O operations timeouts or deadlines.
- Avoid logging secrets, tokens, credentials, PII, or sensitive request bodies.
- Preserve authorization checks when moving code across packages or async boundaries.

## Performance Rules

- Bound collections that grow with input.
- Use maps for membership checks on non-trivial sets.
- Use `strings.Builder` for loop concatenation.
- Avoid avoidable O(n squared) paths on unbounded input.
- Avoid goroutine, timer, ticker, file, response-body, and channel leaks.
- Close response bodies and files.
- Stop tickers and timers when appropriate.
- Do not hold locks during slow operations.

## I/O and Timeouts

- Use context deadlines or client timeouts for external calls.
- Treat missing timeouts as correctness risk when calls are on request paths or workers.
- Avoid retry loops without limits, backoff, or context cancellation.
- Keep long-running workers observable and cancellable.

## Review Red Flags

- `http.Client{}` without timeout in production path.
- SQL built through string concatenation.
- `exec.Command("sh", "-c", ...)` with dynamic input.
- `math/rand` for tokens or secrets.
- `InsecureSkipVerify: true`.
- unbounded map/slice growth from request input.
- goroutine launched without cancellation or bounded lifetime.
- mutex held around network or disk I/O.
