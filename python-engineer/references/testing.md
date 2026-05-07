# Python Testing

Use this for adding, changing, or reviewing Python tests.

## Table of Contents

- Coverage expectations
- pytest layout and discovery
- Test shape
- Fixtures
- Parametrization
- Mocking and monkeypatching
- Determinism
- Review findings

## Coverage Expectations

Add or update tests for:

- behavior changes
- bug fixes
- exported/public functions
- non-trivial branches
- error paths
- async/concurrent behavior
- data parsing and validation
- security-sensitive boundaries

For bug fixes, write a reproducing regression test first when practical.

## pytest Layout and Discovery

Prefer the repo's existing test layout. For new projects, a common layout is:

```text
pyproject.toml
src/
  package/
tests/
  test_feature.py
```

Rules:

- Follow existing discovery patterns.
- Keep tests outside app code unless the repo already co-locates tests.
- Name test files and functions according to the configured test runner.
- If the project uses `src/`, run tests against installed/editable package behavior where practical.

## Test Shape

- Prefer tests through public behavior.
- Avoid asserting private implementation state unless no observable contract exists.
- Use plain `assert` with pytest when the repo uses pytest.
- Use `pytest.raises` for expected exceptions.
- Keep each test's arrange/act/assert phases readable.
- Failure messages should include useful context when default assertion introspection is not enough.

Behavior test pattern:

```python
def test_load_config_rejects_missing_required_field(tmp_path: Path) -> None:
    path = tmp_path / "config.json"
    path.write_text("{}", encoding="utf-8")

    with pytest.raises(ConfigError, match="required field"):
        load_config(path)
```

## Fixtures

Fixture rules:

- Prefer explicit fixtures requested by test parameters.
- Keep fixture scope as narrow as practical.
- Avoid autouse fixtures unless they enforce global safety or repo convention.
- Use `tmp_path` for filesystem tests.
- Use fixture factories for repeated setup with small variations.
- Keep teardown reliable with `yield` fixtures or context managers.

Fixture smells:

- fixture hides important test setup
- session-scoped fixture leaks mutable state
- autouse fixture changes global behavior unexpectedly
- fixture has assertions unrelated to setup

## Parametrization

Use parametrization when cases share:

- same behavior
- same setup shape
- same assertion shape
- small input/output variations

Do not parametrize unrelated behaviors into one test just to reduce line count.

Pattern:

```python
@pytest.mark.parametrize(
    ("raw", "expected"),
    [
        pytest.param(" yes ", True, id="truthy-with-whitespace"),
        pytest.param("no", False, id="falsey"),
    ],
)
def test_parse_bool(raw: str, expected: bool) -> None:
    assert parse_bool(raw) is expected
```

## Mocking and Monkeypatching

Mock external boundaries, not code owned by the module under test.

Good boundaries:

- network calls
- filesystem failures
- time
- randomness
- environment variables
- subprocesses
- third-party service clients

Rules:

- Patch where the object is looked up, not where it is defined.
- Prefer fakes for domain dependencies when behavior matters.
- Use `autospec`/`spec_set` when using `unittest.mock` on stable APIs.
- Use pytest `monkeypatch` for environment variables and simple attribute replacement.
- Do not mock private helpers just to assert call order.

## Determinism

Avoid:

- real network
- arbitrary sleeps
- wall-clock dependence
- shared global state leaks
- order dependence
- unbounded polling
- random data without seed/control
- tests depending on local timezone or locale

Prefer:

- fake clocks
- `tmp_path`
- dependency injection at real external boundaries
- bounded polling with timeouts
- explicit cleanup
- deterministic fixture data

## Review Findings

Missing regression:

- Problem: bug fix lacks test that would fail before fix.
- Fix: add failing test around public behavior.

Over-mocked test:

- Problem: test asserts private collaboration instead of outcome.
- Fix: test observable behavior and mock only boundary.

Hidden global mutation:

- Problem: test changes env/path/module state without cleanup.
- Fix: use `monkeypatch` or context manager.

Nondeterministic async:

- Problem: sleep-based timing.
- Fix: await explicit signal, use fake clock, or bound polling.
