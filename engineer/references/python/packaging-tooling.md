# Packaging and Tooling

Use this when touching packaging, dependencies, `pyproject.toml`, lint/format/type-check config, entry points, package layout, or lock files.

## Table of Contents

- Packaging stance
- pyproject.toml
- Dependencies
- Project layout
- Entry points and CLIs
- Format, lint, and type check
- Lock files
- Common review findings

## Packaging Stance

- Follow the repo's existing packaging tool before introducing a new one.
- Prefer `pyproject.toml` for build-system and project metadata in modern projects.
- Do not change build backend, package layout, or dependency groups unless required.
- Preserve supported Python versions.
- Treat lock files as generated artifacts; update them only with the established tool.

## pyproject.toml

Common sections:

- `[build-system]`: build backend and build requirements.
- `[project]`: name, version, dependencies, optional dependencies, scripts, metadata.
- `[tool.*]`: tool-specific config for pytest, ruff, mypy, coverage, build tools.

Review:

- Are dependencies in the right group?
- Does `requires-python` match code syntax and CI?
- Are optional extras named by use case?
- Are tool configs consistent with commands in CI?
- Did a change require lock-file regeneration?

## Dependencies

Dependency rules:

- Prefer standard library for simple tasks.
- Reuse existing dependencies before adding new ones.
- Add a dependency only when it materially reduces complexity or risk.
- Check import weight and transitive dependency risk for hot paths or libraries.
- Avoid adding runtime dependencies for test-only needs.
- Pin or constrain versions according to project convention.

Questions before adding:

- Is this runtime, dev, test, docs, or optional?
- Is there a maintained existing dependency in the repo?
- Does it support the repo's Python versions?
- Does it change packaging, licensing, or deployment?

## Project Layout

Common modern layout:

```text
src/
  package_name/
tests/
pyproject.toml
```

Rules:

- Follow existing layout.
- Keep importable package code separate from scripts when repo does so.
- Avoid adding top-level modules that shadow stdlib or installed packages.
- Keep tests aligned with package import mode.
- Do not add `__init__.py` files casually in namespace-package repos.

## Entry Points and CLIs

For command-line interfaces:

- Prefer existing CLI framework.
- Use `argparse` for simple stdlib CLIs.
- Keep parsing/wiring separate from business logic.
- Return exit codes from a `main()` function where project style supports it.
- Avoid `sys.exit()` deep in library code.
- Make errors actionable.

Entry-point pattern:

```python
def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv)
    run(args)
    return 0
```

## Format, Lint, and Type Check

Use existing tooling:

- Ruff may be configured for linting and/or formatting.
- Black, isort, flake8, pylint, mypy, pyright, or pyre may already be used.
- Do not introduce a formatter or linter in a feature change unless requested.

Validation approach:

1. Discover commands from README, `pyproject.toml`, `Makefile`, CI, tox, nox, uv, poetry, hatch, or scripts.
2. Run focused tests first.
3. Run formatter/linter/type checker for touched files when available.
4. Run broader checks when risk or scope justifies it.

## Lock Files

Lock files may include:

- `uv.lock`
- `poetry.lock`
- `Pipfile.lock`
- `requirements*.txt`
- `constraints*.txt`

Rules:

- Do not hand-edit lock files.
- Regenerate with the repo's tool.
- Avoid dependency churn unrelated to the task.
- Check whether dependency changes require CI or deployment updates.

## Common Review Findings

Wrong dependency group:

- Problem: test dependency added as runtime dependency.
- Fix: move to test/dev optional group.

Unsupported syntax:

- Problem: code uses Python syntax newer than `requires-python`.
- Fix: adjust syntax or supported version metadata.

Tool drift:

- Problem: new config conflicts with existing CI command.
- Fix: align config and command or avoid tool change.

Manual lock edit:

- Problem: lock file changed without package metadata or generated format.
- Fix: regenerate with project tool.
