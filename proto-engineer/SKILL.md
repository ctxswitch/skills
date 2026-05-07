---
name: proto-engineer
description: "Implement focused Protocol Buffers changes. Use when asked to add, fix, or modify .proto schemas, protobuf messages, fields/tags, enums, oneofs, services/RPCs, gRPC or ConnectRPC APIs, Buf/protoc generation, lint config, breaking-change policy, generated clients, wire/JSON compatibility, or schema evolution."
---

# Proto Engineer

Write evolvable protobuf schemas. Treat `.proto` files as cross-language API contracts, not local implementation details.

## Workflow

1. Identify the schema owner, package, generated languages, consumers, and wire/JSON compatibility requirements before editing.
2. Inspect existing package layout, naming, lint/breaking config, generation commands, and generated-code ownership.
3. Make the smallest schema change that solves the requested behavior.
4. Preserve compatibility unless the user explicitly approves a breaking change and rollout path.
5. Regenerate code only through the repo's established `buf`, `protoc`, Makefile, or build-system command.
6. Validate with available schema lint, breaking checks, generation, compile/type checks, and consumer tests.
7. Stop and ask when correctness depends on API versioning, field presence, JSON names, unknown-field behavior, enum openness, rollout order, or generated-language compatibility.

## Loading Rule

- Read `references/schema-design.md` before adding or changing messages, fields, enums, oneofs, packages, imports, options, or services.
- Read `references/compatibility.md` before deleting, renaming, renumbering, moving, changing types, changing oneofs, changing JSON-visible names, or touching existing public schemas.
- Read `references/services-generation.md` when touching services/RPCs, gRPC APIs, generated clients, language options, plugins, or generated files.
- Read `references/connectrpc.md` when touching ConnectRPC/Connect services, handlers, clients, interceptors, transports, generated Connect stubs, gRPC/gRPC-Web compatibility, browser clients, or Connect protocol behavior.
- Read `references/tooling-validation.md` when touching `buf.yaml`, `buf.gen.yaml`, `buf.lock`, `protoc` flags, build scripts, lint/breaking config, generated code, or schema tests.
- For mixed-language effects, also use `$engineer` or the repo's normal language tooling after schema generation.

Load references incrementally. Prefer the most specific file for the changed schema.

## Implementation Stance

- Never reuse field numbers or enum numbers.
- Reserve deleted field numbers and names; reserve deleted enum numbers and names.
- Prefer additive changes for live APIs.
- Keep packages, file paths, imports, and language options consistent with local convention.
- Do not hand-edit generated files.
- Do not hide a breaking change by weakening lint or breaking-change config.
- Include or update tests/fixtures when schema behavior, JSON mapping, validation, or service contracts change.

## Report

When done, report only:

- Proto files and generation/config files modified.
- Compatibility assumptions or rollout risks.
- Generated code status.
- Lint, breaking, generation, compile, and test status.
