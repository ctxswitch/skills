# Security and Performance

Use this for Go security, resource, and performance checks.

## Security

- Use `crypto/rand` for keys, tokens, nonces, salts, and session IDs. `math/rand` is the reflex and it is wrong for all of these.
- Use `subtle.ConstantTimeCompare` for secrets and tokens. `==` is the reflex and it leaks timing.
- Use `exec.Command(name, args...)`. `exec.Command("sh", "-c", ...)` with any dynamic input is injection.
- Give every production HTTP client and I/O operation a timeout or deadline. `http.Client{}` has none, and the zero value is what gets written.
- Preserve authorization checks when moving code across packages or async boundaries. A worker that inherits no caller authority is the common way this silently breaks.

## Resources and performance

- Bound collections that grow with request input.
- Avoid goroutine, timer, ticker, file, response-body, and channel leaks. Close response bodies and files; stop tickers and timers.
- Do not hold a lock across network or disk I/O.
- Avoid retry loops without limits, backoff, or context cancellation.
- Keep long-running workers observable and cancellable.
- Treat a missing timeout as a correctness risk, not a performance one, when the call is on a request path or in a worker.

## Review red flags

- `http.Client{}` without timeout in a production path.
- SQL built through string concatenation.
- `exec.Command("sh", "-c", ...)` with dynamic input.
- `math/rand` for tokens or secrets.
- `InsecureSkipVerify: true`.
- unbounded map/slice growth from request input.
- goroutine launched without cancellation or bounded lifetime.
- mutex held around network or disk I/O.
