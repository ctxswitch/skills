# Python Standards

Use this for implementation and review of general Python code. Prefer the repo's established conventions when they conflict with generic guidance.

## Table of Contents

- Core rules
- Imports and modules
- Functions and classes
- Exceptions
- Logging
- Data model choices
- Documentation and comments
- Common review findings

## Core Rules

- Readability matters more than cleverness.
- Follow existing project style before introducing new style rules.
- Prefer simple functions and cohesive modules over deep inheritance.
- Keep public APIs small and explicit.
- Avoid module import side effects except constants, type declarations, and cheap setup.
- Avoid mutable default arguments.
- Avoid broad `except:` and bare `except Exception` without a concrete recovery or boundary.
- Prefer context managers for resources.
- Keep dependencies narrow and justified.
- Do not add framework magic when ordinary Python is clearer.

## Imports and Modules

Import rules:

- Keep imports at module top unless delayed import solves a real cycle, optional dependency, or performance problem.
- Use absolute imports unless the package already uses relative imports consistently.
- Avoid wildcard imports outside `__init__.py` export shims.
- Remove unused imports.
- Do not create import cycles to share constants or types.
- Guard typing-only imports with `if TYPE_CHECKING:` when they cause runtime cycles or heavy imports.

Module rules:

- Keep modules organized around domain responsibility, not generic utility buckets.
- Avoid new `utils.py`, `helpers.py`, `common.py`, or `misc.py` modules unless the repo already uses that convention and the responsibility is clear.
- Keep executable script wiring separate from business logic.
- Avoid doing network, filesystem, database, or logging configuration work at import time.

## Functions and Classes

Function rules:

- Prefer explicit parameters over hidden globals.
- Keep functions focused on one responsibility.
- Return a clear value or raise a clear exception; avoid mixed sentinel/error patterns unless established.
- Use keyword-only parameters when they prevent confusing call sites.
- Avoid boolean flag arguments that create multiple unrelated behaviors.
- Prefer small private helpers only when they clarify a real subtask.

Class rules:

- Use classes when state, protocol, or cohesive behavior matters.
- Avoid classes that only namespace stateless functions.
- Prefer composition over inheritance unless polymorphism is central.
- Keep `__init__` cheap and unsurprising.
- Avoid property methods that perform expensive I/O or mutation.

## Exceptions

Exception rules:

- Catch the narrowest exception that can be handled.
- Add context when re-raising across a boundary.
- Preserve traceback with bare `raise` inside an except block.
- Use exception chaining (`raise X from exc`) when translating exceptions.
- Do not swallow cancellation or termination exceptions in async or worker code.
- Use custom exceptions when callers need a stable way to branch.
- Do not use exceptions for normal tight-loop control flow in hot paths.

Boundary pattern:

```python
try:
    data = load_config(path)
except OSError as exc:
    raise ConfigError(f"failed to read config {path}") from exc
```

## Logging

Logging rules:

- Libraries should get named loggers with `logging.getLogger(__name__)`.
- Libraries should not call `basicConfig()` at import time.
- Use structured context where the repo's logging stack supports it.
- Do not log secrets, tokens, credentials, PII, or sensitive request bodies.
- Include operational context, not noisy implementation detail.
- Use lazy `%s` formatting for standard logging calls unless the repo uses structured logging.

Level guidance:

- `debug`: diagnostic detail.
- `info`: meaningful lifecycle event.
- `warning`: unexpected but handled condition.
- `error`: operation failed and caller/operator should know.
- `exception`: inside exception handlers when traceback is useful.

## Data Model Choices

Use:

- `dataclass` for simple domain/value objects when behavior is limited.
- `frozen=True` for values that should not mutate.
- `Enum` when the set of values is closed and behavior benefits from named members.
- `TypedDict` or dataclass for structured dicts depending on runtime needs.
- `pathlib.Path` for path manipulation when project style permits.

Avoid:

- passing around untyped nested dictionaries when the shape is stable and important.
- mutable class attributes for instance state.
- global mutable state without lifecycle ownership.
- storing derived state that can drift unless performance requires it.

## Documentation and Comments

Docstring rules:

- Public modules, classes, functions, and methods should be documented when behavior is not obvious from name/signature.
- Use docstrings to explain behavior, side effects, exceptions, and restrictions.
- Do not restate the signature in prose.
- Keep comments current; a stale comment is worse than none.

Comment rules:

- Explain why, not what.
- Comment non-obvious invariants, ordering, compatibility constraints, and workarounds.
- Remove commented-out code.

## Common Review Findings

Mutable default:

- Problem: shared state across calls.
- Fix: default to `None` and create inside.

Broad exception:

- Problem: hides failures or catches wrong boundary.
- Fix: catch narrow exceptions and re-raise with context.

Import side effect:

- Problem: importing module performs I/O, configures global state, or starts work.
- Fix: move work behind function, CLI entry point, or app startup.

Unclear module boundary:

- Problem: new helper module collects unrelated behavior.
- Fix: place behavior with owner or create cohesive module.

Logging leak:

- Problem: secret or sensitive payload is logged.
- Fix: log identifiers, counts, states, or redacted values.
