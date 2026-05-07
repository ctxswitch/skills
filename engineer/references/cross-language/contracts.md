# Cross-Language Contracts

Use this reference when a change crosses language, package, service, frontend/backend, generated-code, schema, or tooling boundaries.

## Core Stance

- Identify both sides of a contract before changing either side.
- Prefer changing the source of truth, then regenerate or update dependents through the repo's existing tooling.
- Validate each affected language/package with its local tools.
- Do not hand-edit generated clients, schemas, protobuf output, OpenAPI clients, GraphQL types, ORM output, or bindings unless that is the established workflow.
- Keep backward compatibility explicit. Know whether the change is additive, breaking, version-gated, feature-gated, or migration-dependent.

## Boundaries To Check

- API server and generated/client code.
- Protobuf, OpenAPI, GraphQL, JSON Schema, Avro, SQL schema, migrations, or event contracts and their consumers.
- Backend validation and frontend form/state assumptions.
- CLI flags/output and shell scripts, docs, or automation that parse them.
- Database migrations and application code that reads/writes the changed shape.
- Rust/Python/Go/TypeScript bindings around FFI, subprocesses, or shared file formats.
- Package exports and downstream imports across workspace packages.

## Implementation Rules

- Inspect callers/consumers before changing a public shape.
- Keep old and new formats compatible during rollout when data or clients can outlive the deploy.
- Update tests on both sides of a contract when behavior changes.
- Preserve generated-file ownership and lockfile/package metadata integrity.
- When contract drift is possible, add or update a test that exercises the boundary instead of only unit-testing one side.

## Common Findings

- Server accepts or returns a shape that the client types no longer match.
- Frontend validation allows a state backend validation rejects, or vice versa.
- Generated code was edited directly instead of regenerated.
- API/schema change lacks a migration, versioning, or rollout path.
- Only one language's tests ran after a cross-language contract changed.
