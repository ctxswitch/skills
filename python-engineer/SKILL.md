---
name: python-engineer
description: "Implement focused, idiomatic Python changes. Use when asked to add, fix, or modify Python code, tests, packages, CLIs, async, typing, packaging, errors, logging, security, or production behavior."
---

# Python Engineer

Write correct, idiomatic Python. Stay in scope, match the repository's existing style, and prefer narrow changes that preserve module boundaries.

## Workflow

1. Verify before use. Read or search definitions before calling repo APIs, importing helpers, assuming attributes, or trusting a helper mentioned in the prompt.
2. Diagnose before fixing. Read the actual error, failing test, traceback, or surrounding behavior before editing.
3. Keep edits narrow. Do not refactor, rename, reorganize, or improve unrelated code.
4. Protect repository boundaries. Check generated files, vendored files, lock files, and ignored paths before editing.
5. Validate incrementally. Prefer focused tests for affected packages/modules. Run formatters, linters, and type checks only when they exist in the repo or the scope justifies them.
6. Stop and ask when correctness depends on an ambiguous product, API, data-model, or compatibility decision.

## Loading Rule

- Read `references/python-standards.md` before making non-trivial production Python changes, changing public APIs, adding modules, touching imports, exceptions, logging, or module structure.
- Read `references/typing-and-api-design.md` when adding or reviewing type annotations, protocols, dataclasses, public interfaces, overloads, generics, or compatibility with type checkers.
- Read `references/testing.md` before adding, changing, or reviewing Python tests, fixtures, mocks, monkeypatching, or regression coverage.
- Read `references/packaging-tooling.md` when touching `pyproject.toml`, dependencies, package layout, entry points, lint/format config, build config, or lock files.
- Read `references/async-and-resources.md` when touching `asyncio`, concurrent work, file/network/database resources, context managers, cancellation, or cleanup.
- Read `references/security-performance.md` when handling external input, secrets, randomness, subprocesses, SQL, deserialization, HTTP, path handling, unbounded data, or hot paths.
- For small mechanical edits, load only the specific reference that applies.

## Implementation Stance

- Make the smallest change that solves the requested behavior.
- Prefer existing project tooling and style over introducing Ruff, pytest, mypy, or packaging changes.
- Add abstractions only when they hide real complexity or match an established local boundary.
- Preserve supported Python versions and dependency constraints.
- Do not mock code owned by the repo just to make private structure testable.
- Do not hand-edit generated files.
- Run focused validation before reporting completion.

## Report

When done, report only:

- Files modified and what changed.
- Assumptions worth review.
- Unrelated issues noticed.
- Test, type-check, lint, format, and build status.
