# Protocol Buffers, gRPC, and ConnectRPC

Each row is a change you would make by reflex. The reflex is wrong; do the third column instead. Old clients, stored bytes, queues, and logs outlive every deploy.

| Reflex | Why it is wrong | Instead |
|---|---|---|
| Reusing or renumbering a field or enum value | Old readers decode garbage | A new number; `reserved` for the old |
| Deleting a field without `reserved` | The number gets reused later | Reserve the number and the name |
| Renaming a field, enum value, service, or RPC | Breaks JSON, text format, and generated API even when the wire survives | Keep the name; add the new one and deprecate |
| Changing a field's type, cardinality, or `oneof` membership | Wire break | Add a field |
| `FOO_FIRST = 0` as a meaningful value | Unset is indistinguishable from the value | `FOO_UNSPECIFIED = 0` |
| `optional` on every field | Presence semantics nobody uses | Only where presence matters |
| A scalar request or response | Cannot grow | Explicit request and response messages |
| `page_size`, `page_token`, `field_mask`, an idempotency key, "for later" | A caller that does not exist | Add them when the RPC has the rows or the retry that needs them |
| `google.protobuf.Any` for an open payload | The contract is lost | Only when type URL handling is the contract |
| Tightening validation on a field with existing data | Stored rows fail | Migrate first |
| Hand-editing generated code | Regenerated over | Regenerate; compile every generated language, not only the one being edited |
| Weakening `buf breaking` or lint config to pass | Hides the break | State the compatibility decision in the PR |
| grpc-go registration, gRPC transport, or a gRPC client on a Connect API | This repo's policy is the Connect protocol over HTTP/2 with no gRPC transport | Connect handlers and clients. If gRPC transport is proposed, stop and ask for an explicit architecture decision. |
