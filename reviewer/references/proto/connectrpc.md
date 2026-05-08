# ConnectRPC

Use this reference for ConnectRPC/Connect services, handlers, clients, generated stubs, interceptors, transports, browser clients, and HTTP/2 behavior.

## Core Stance

- Connect APIs are protobuf RPC contracts that should use the Connect protocol over HTTP/2.
- Treat the `.proto` service as the source of truth. Generated Connect handlers and clients should come from the repo's Buf/protoc generation workflow.
- Do not use gRPC transport for ConnectRPC services. If gRPC transport compatibility is proposed, stop and ask for an explicit architecture decision.
- Check protocol, HTTP/2 transport, streaming, headers/trailers, error details, compression, CORS, and browser constraints.
- Keep handler/client changes aligned with schema compatibility rules.
- Validate generated stubs and consumers in every language the repo uses.

## Schema and API Design

- Use explicit request and response messages for RPCs.
- Design RPC names, request fields, response fields, pagination, idempotency, and partial-update semantics as public API.
- Streaming RPCs need clear cancellation, backpressure, ordering, timeout, and retry semantics.
- Browser-facing Connect clients require attention to CORS, credentials, headers, streaming support, and JSON/protobuf codec choices.
- Error behavior should follow the repo's Connect status and error-detail convention.

## Generation and Imports

- For Go, Connect stubs are commonly generated with `protoc-gen-connect-go` or the Buf remote plugin `buf.build/connectrpc/go`.
- Connect-generated Go code often lives in a separate subpackage, such as a `*connect` package. Keep import paths and package names consistent with existing generated code.
- For TypeScript/web, check the repo's connect-es or generated SDK workflow before editing clients.
- Do not hand-edit generated Connect code.
- If `buf.gen.yaml` changes plugins, output paths, or plugin versions, regenerate and compile affected consumers.

## Implementation Boundaries

- Go Connect handlers are ordinary HTTP handlers and usually integrate with `net/http`, existing middleware, observability, auth, and routing.
- Client/server options such as compression, codecs, timeouts, h2c, interceptors, and base URLs are runtime behavior, not just schema details.
- Interceptors affect every RPC on the path; review auth, tracing, logging, retries, idempotency, and error mapping carefully.
- Do not add grpc-go service registration, gRPC transport handlers, or gRPC transport clients for ConnectRPC APIs unless explicitly requested.
- Health checks, validation, and observability may live in separate packages; follow local convention.

## Validation

- Run schema lint and breaking checks.
- Regenerate Connect stubs with the repo's configured command.
- Compile generated server/client packages.
- Test handler registration, client calls, error mapping, auth/interceptors, and browser/CORS behavior when touched.
- For compatibility-sensitive APIs, test Connect over HTTP/2 and the client transports the repo actually supports.

## Common Findings

- Schema changes are made without regenerating Connect stubs.
- Connect handler/client code introduces or relies on gRPC transport instead of Connect over HTTP/2.
- Browser client changes miss CORS, credentials, or streaming constraints.
- Generated Connect package path moves and breaks imports.
- Interceptor change alters auth, tracing, error mapping, or retry semantics globally.
- Service/RPC rename breaks generated clients even when wire message fields remain compatible.
