# Protocol Buffers

A `.proto` file is a contract that old clients, stored bytes, queues, and logs all outlive. The failure to handle is a change that assumes a synchronized deploy.

- Never reuse or change a field or enum number. Reserve number and name when deleting.
- Enum zero is `FOO_UNSPECIFIED`, never a meaningful value.
- Renames break JSON clients even when the binary wire survives. Field, enum value, service, and RPC names are public.
- Add fields. Do not change a field's type, cardinality, or `oneof` membership.
- Do not hand-edit generated code. Regenerate with the repo's command and compile every generated language, not only the one being edited.
- Run the repo's lint and breaking checks. Do not weaken their configuration to pass.
