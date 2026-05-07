# Services and Generation

Use this reference for services/RPCs, gRPC APIs, generated clients, language options, plugins, and generated files.

## Services and APIs

- RPCs should have explicit request and response messages.
- Request messages should leave room for future fields, idempotency keys, pagination, filtering, field masks, and caller metadata when relevant.
- Response messages should separate result data from pagination, warnings, partial failures, and operation metadata.
- Streaming RPCs need clear client/server stream ownership, cancellation, retry, ordering, and backpressure semantics.
- Errors should follow the repo's gRPC/status/error detail convention.
- API names should be stable; renaming a service/RPC often breaks generated clients and docs.

## Generation

- Use the repo's established generation command. Common tools include `buf generate`, `protoc`, Make, Bazel, Gradle, npm scripts, or language-specific build tools.
- Do not hand-edit generated code.
- Generated-code output paths are part of the API for many languages. Moving files can break imports even if wire compatibility is preserved.
- Keep plugin versions, remote plugins, local plugins, and lock files consistent with repo policy.
- Check all generated languages used by the repo, not just the one currently being edited.
- If generated code is not checked in, validate generation and compile/tests that consume generated output.

## Language Options

- `go_package`, `java_package`, `java_outer_classname`, C# namespace, Python package layout, and other options affect imports and generated API shape.
- Avoid changing language options in existing public protos without checking all downstream imports.
- Keep proto package, language package, and directory structure intentionally related but not blindly identical.

## Common Findings

- RPC uses scalar request/response types instead of versionable messages.
- Generated code is stale after schema changes.
- Generator config changed without updating lock files or CI commands.
- Language option change moves generated imports.
- Streaming RPC lacks cancellation/backpressure semantics.
- Only one generated language was checked after shared schema changed.
