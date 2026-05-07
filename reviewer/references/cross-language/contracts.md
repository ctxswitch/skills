# Cross-Language Contracts

Use this reference when a review crosses language, package, service, frontend/backend, generated-code, schema, or tooling boundaries.

## Review Stance

- A change to one side of a contract is incomplete until the other side is inspected.
- Generated code should match the source of truth and the repo's generation workflow.
- Mixed-language changes need validation in every affected language/package, not only the package where the diff is largest.
- Backward compatibility, rollout order, and persisted data shape matter when clients, workers, databases, queues, or events can outlive a deploy.

## Boundaries To Check

- API server and generated/client code.
- Protobuf, OpenAPI, GraphQL, JSON Schema, Avro, SQL schema, migrations, or event contracts and their consumers.
- Backend validation and frontend form/state assumptions.
- CLI flags/output and shell scripts, docs, or automation that parse them.
- Database migrations and application code that reads/writes the changed shape.
- Rust/Python/Go/TypeScript bindings around FFI, subprocesses, or shared file formats.
- Package exports and downstream imports across workspace packages.

## Common Findings

- Server accepts or returns a shape that the client types no longer match.
- Frontend validation allows a state backend validation rejects, or vice versa.
- Generated code was edited directly instead of regenerated.
- API/schema change lacks a migration, versioning, or rollout path.
- Only one language's tests ran after a cross-language contract changed.
- A package export changed without checking downstream imports.
