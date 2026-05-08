# Proto Schema Design

Use this reference for `.proto` package layout, messages, fields, enums, oneofs, imports, options, and services.

## Core Stance

- A `.proto` file is a long-lived cross-language contract. Design for old and new clients/servers coexisting.
- Follow the repository's existing syntax or edition, package versioning, file layout, language options, lint policy, and generation strategy.
- Prefer additive schemas. Avoid requiring synchronized client/server deploys.
- Keep semantic API shape separate from generated-language quirks, but check generated-language impact before exposing a new pattern.
- Keep names readable in both proto and generated code.

## File and Package Layout

- Use `lower_snake_case.proto` filenames unless local convention says otherwise.
- Keep `syntax` or `edition`, package, imports, and options ordered according to local or official style.
- Package names should be lower_snake_case dot-delimited names and should not be Java package names.
- Keep files for the same package in the same directory when using Buf-style layouts.
- Imports should be sorted and used. Avoid public/weak imports unless the repo intentionally uses them.
- Use language options, such as `go_package` or `java_package`, consistently with the repo's generated-code layout.

## Messages and Fields

- Use TitleCase for message names and snake_case for field names.
- Use plural names for repeated fields.
- Choose field numbers deliberately. Low numbers are cheaper on the wire, but compatibility matters more than packing.
- Do not change a field number once a message is in use.
- Use `optional` only when presence matters; otherwise rely on ordinary proto3 defaults according to local semantics.
- Avoid large messages with hundreds of fields. Split by lifecycle, ownership, or domain concept when size starts hiding invariants.
- Prefer well-known types for timestamps, durations, wrappers, field masks, empty messages, status details, and structured values when they fit.
- Use `oneof` for mutually exclusive alternatives, not as a presence hack without clear semantics.
- Avoid `Any` unless the set of possible payloads is genuinely open and type URL handling is part of the contract.
- Avoid ambiguous maps when ordering, duplicates, validation, or per-entry metadata matters.

## Enums

- Use TitleCase for enum types and UPPER_SNAKE_CASE for values.
- The first enum value should be zero and represent an unspecified/unknown default, commonly `FOO_UNSPECIFIED`.
- Do not use negative enum values.
- Avoid aliases unless the repo has a specific migration reason and rollout sequence.
- Prefix enum values when needed to avoid cross-language or C++ namespace collisions.
- Model open-ended externally controlled values carefully; an integer/string may preserve unknown values better than an enum in some APIs.

## Services and RPCs

- Use services/RPCs only when the `.proto` owns an RPC contract, not merely a data shape.
- Request and response messages should be explicit and versionable. Avoid naked scalar request/response types.
- Streaming RPCs need backpressure, cancellation, ordering, retry, and timeout semantics in the API contract.
- Include pagination, filtering, field masks, idempotency keys, and resource names when the operation semantics need them.

## Common Findings

- Field presence is unclear, so clients cannot distinguish unset from default.
- Enum zero value is semantically meaningful instead of unspecified.
- Package or language option moves generated code unexpectedly.
- A new field duplicates an existing concept under a different name.
- `oneof`, `Any`, or map usage hides validation or rollout semantics.
- RPC request/response shape leaves pagination, idempotency, or partial update behavior ambiguous.
