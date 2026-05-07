# Security and Performance

Use this for Python security, resource, and performance checks.

## Table of Contents

- Security rules
- Input and deserialization
- Secrets and randomness
- Subprocesses
- SQL and storage
- HTTP and network
- Path handling
- Performance rules
- Common review findings

## Security Rules

- No hardcoded secrets. Read credentials from environment, config, or secret store.
- Do not log secrets, tokens, credentials, PII, or sensitive request bodies.
- Validate and normalize external input at boundaries.
- Prefer safe parsers and serializers.
- Avoid dynamic code execution.
- Parameterize SQL.
- Use secure randomness for secrets.
- Bound user-controlled sizes and loops.
- Preserve authorization checks when moving work across functions, processes, queues, or async tasks.

## Input and Deserialization

Review:

- `eval`, `exec`, dynamic import, or template execution with untrusted input.
- unsafe YAML/pickle/deserialization.
- JSON parsed into unvalidated nested dictionaries that spread through code.
- regexes with potential catastrophic backtracking on untrusted input.
- missing size limits for uploads, files, payloads, or lists.

Rules:

- Never unpickle untrusted data.
- Avoid `eval`/`exec`; use explicit parsers.
- Validate at boundaries and convert to typed/domain objects where practical.

## Secrets and Randomness

Rules:

- Use `secrets` for tokens, passwords, reset codes, API keys, and security-sensitive randomness.
- Use `random` only for simulations, sampling, non-security behavior, or tests.
- Use constant-time comparison for secrets/tokens when equality result is security-sensitive.
- Do not store recoverable passwords.
- Redact secrets in exceptions and logs.

## Subprocesses

Rules:

- Prefer `subprocess.run([...], check=True, timeout=...)` with an argument list.
- Avoid `shell=True`; never combine `shell=True` with untrusted input.
- Set timeouts for external commands.
- Capture and handle output intentionally.
- Avoid leaking secrets through command args when process listings are visible.

## SQL and Storage

Rules:

- Parameterize SQL; do not interpolate user input.
- Keep transaction ownership clear.
- Avoid building query fragments from unchecked strings.
- Validate file/database paths derived from user input.
- Handle integrity and operational errors at the right boundary.

## HTTP and Network

Rules:

- Set timeouts for HTTP and network calls.
- Validate URLs when user-controlled.
- Avoid disabling TLS verification.
- Limit redirects when relevant.
- Be careful with SSRF risks when fetching user-provided URLs.
- Do not retry non-idempotent operations blindly.

## Path Handling

Rules:

- Use `pathlib.Path` where project style permits.
- Normalize and check containment for user-controlled paths.
- Avoid joining user input into privileged paths without validation.
- Use temporary-file APIs for temp paths.
- Specify encoding for text files when deterministic behavior matters.

Containment pattern:

```python
root = root.resolve()
target = (root / user_path).resolve()
if root not in target.parents and target != root:
    raise ValueError("path escapes root")
```

## Performance Rules

- Bound collections that grow with input.
- Avoid repeated O(n) membership checks; use sets/dicts when useful.
- Avoid string concatenation in loops; use `''.join(...)` or `io.StringIO`.
- Stream large files and responses.
- Avoid unnecessary global imports in hot CLI startup paths only when measured.
- Do not cache mutable objects globally unless lifecycle is clear.
- Prefer clarity until there is evidence of a hot path.

## Common Review Findings

Unsafe shell:

- Problem: command string includes dynamic input.
- Fix: argument list, no shell, timeout, validation.

Insecure randomness:

- Problem: `random` used for token.
- Fix: `secrets.token_urlsafe()` or equivalent.

Missing timeout:

- Problem: HTTP/subprocess can hang worker.
- Fix: add timeout and error handling.

Path traversal:

- Problem: user path escapes root.
- Fix: resolve and enforce containment.

Unbounded memory:

- Problem: reads entire user-controlled file/response.
- Fix: stream or enforce size.
