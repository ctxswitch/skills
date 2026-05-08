# Tooling and Validation

Use this reference for Buf, `protoc`, linting, breaking checks, generated-code config, schema tests, and CI validation.

## Core Stance

- Prefer the repo's existing schema toolchain and policies.
- Do not weaken lint or breaking-change configuration to make a local change pass.
- Generated files and lock files should be produced by tools, not edited by hand.
- Validation should match CI where possible.

## Buf

- `buf lint` enforces schema style and consistency according to configured categories/rules.
- `buf breaking` checks compatibility against a configured baseline or input.
- Buf breaking categories have different scopes: generated source, package, wire/JSON, and wire-level compatibility. Pick the category that matches the repo's compatibility promise.
- `buf.yaml`, `buf.gen.yaml`, and `buf.lock` changes can affect every generated consumer.
- Ignore/except rules should be narrow and justified.

## Protoc and Plugins

- Check import roots, include paths, plugin versions, output paths, and language options.
- Prefer deterministic generation commands.
- Do not mix generation strategies unless the repo already does.
- If protoc plugins are installed out of band, document or use existing setup commands.

## Tests

- Add schema or consumer tests when changing JSON mapping, validation, service behavior, generated clients, or backward compatibility.
- Golden fixtures are useful for wire/JSON contracts but must be updated deliberately.
- Test old/new reader-writer compatibility when changing persisted, queued, event, or public API messages.
- Compile generated clients/server stubs for every affected language package.

## Common Findings

- Lint rule disabled globally for a local naming problem.
- Breaking check baseline updated without explaining the compatibility decision.
- Generated code omitted or stale.
- Schema change lacks consumer compile/test coverage.
- CI uses a different generation command than the local change.
