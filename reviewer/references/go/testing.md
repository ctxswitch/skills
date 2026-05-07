# Go Testing

Use this for adding, changing, or reviewing Go tests.

## Coverage Expectations

Add or update tests for:

- behavior changes
- bug fixes
- exported functions
- non-trivial branches
- error paths
- concurrency behavior
- boundary validation

For bug fixes, write a reproducing regression test first when practical.

## Test Shape

- Prefer tests through public behavior.
- Avoid asserting unexported state unless no observable contract exists.
- Use the package's existing test framework.
- Do not mix assertion styles in one package.
- For new packages, testify is acceptable.
- Table-driven tests need meaningful `name` fields and `t.Run`.
- Use tables when cases vary by input, expected output, boundary, or small configuration.
- Do not force unrelated scenarios into one table.
- Split tests by behavior when the setup, assertion, or contract differs.

## Test Dependencies

Prefer:

- real dependencies when cheap
- `httptest`
- `t.TempDir`
- embedded databases already used by the repo
- small in-memory fakes

Mock only:

- external services
- time, randomness, filesystem, network, or hard-to-trigger boundary failures
- behavior outside the package's ownership

Do not mock code owned by the repo just to make private structure visible.

## Determinism

Avoid:

- arbitrary `time.Sleep`
- real network
- wall-clock dependence
- global state leaks
- unseeded randomness
- order dependence
- unbounded polling

Prefer:

- fake clocks
- contexts and deadlines
- synchronization channels
- temporary directories
- explicit cleanup

## Failure Quality

- Helpers need `t.Helper()`.
- Failure messages should include inputs, got, and want.
- When comparing complex values, use the existing diff/assertion style.
- Keep fixtures small and named by behavior.
- Avoid golden files unless the output is naturally large or format-heavy.

## Review Rules

Treat missing tests as merge-critical when new behavior, bug fixes, exported APIs, non-trivial branches, or error paths are uncovered.

Flag tests that:

- pass without exercising the behavior
- assert implementation detail instead of contract
- are nondeterministic
- use excessive mocks
- omit important failure cases
- require external services without clear integration-test gating
