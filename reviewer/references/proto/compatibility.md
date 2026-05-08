# Proto Compatibility

Use this reference before changing existing schemas, deleting fields, renaming values, changing types, moving files, altering JSON-visible names, or changing public services.

## Core Stance

- Clients and servers are not updated atomically. Old readers, old writers, stored bytes, logs, queues, events, backups, generated clients, and JSON users may outlive the deploy.
- Never reuse field numbers or enum numbers.
- Reserve deleted field numbers and names. Reserve deleted enum numbers and names.
- Binary wire compatibility, JSON compatibility, generated-source compatibility, and semantic API compatibility are different checks. Know which one matters.
- Prefer additive changes: add optional/repeated fields, new enum values, new messages, or new RPCs with compatible behavior.

## Usually Compatible

- Adding a new field with a new number.
- Adding a new enum value when clients tolerate unknown/default values.
- Adding a new message type.
- Adding a new RPC method when service generation and server/client compatibility allow it.
- Adding comments, options that do not affect generated API, or validation annotations that match existing behavior.

## Risky or Breaking

- Reusing field or enum numbers.
- Changing field numbers.
- Renaming fields when JSON, TextProto, reflection, dynamic clients, docs, or generated API names matter.
- Changing field type unless it is one of the narrowly compatible numeric cases and all consumers are checked.
- Moving messages across packages/files when generated-source compatibility matters.
- Changing singular/repeated/map/oneof shape.
- Moving a field into or out of a `oneof`.
- Deleting a field or enum value without reserving number and name.
- Changing enum zero value semantics.
- Changing service, RPC, request, or response names.
- Changing streaming/unary shape.
- Tightening validation in a way old clients cannot satisfy.

## Deleting or Deprecating

- Deprecate first when consumers may still use the field/value/RPC.
- Stop writing the field before removing readers when doing multi-step rollouts.
- Reserve field numbers and names after deletion.
- Reserve enum numbers and names after deletion.
- Keep compatibility tests or breaking-change baselines updated through the repo's tool, not by weakening policy globally.

## JSON and Text Format

- Proto JSON uses names and enum strings, so renames can break clients even when binary wire compatibility survives.
- Text format is for human editing/debugging, not stable interchange.
- Unknown fields and unknown enum handling differ across binary, JSON, languages, and runtimes.
- Changing `json_name` or relying on generated default JSON names is a public API decision if JSON leaves the process.

## Common Findings

- Field was removed but the tag number was not reserved.
- Rename is treated as safe even though JSON clients exist.
- Breaking check category is too weak for the repo's generated-language consumers.
- Server and client changes assume synchronized deploy.
- Validation changed without a migration path for existing data.
