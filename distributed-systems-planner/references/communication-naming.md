# Communication, Naming, and Discovery

Use this for RPC, queues, streams, multicast/gossip, service discovery, naming, API boundaries, and client/server interaction patterns.

## Table of Contents

- Communication model selection
- RPC
- Messaging and queues
- Streams
- Multicast and gossip
- Naming and identity
- Service discovery
- API and schema boundaries
- Review checklist
- Test cases

## Communication Model Selection

Choose communication style from the workflow:

- RPC: immediate request/response with bounded dependency and clear caller ownership.
- Queue/event: decoupled work, buffering, fan-out, eventual completion, retryable workflows.
- Stream: ordered or time-sensitive continuous data where freshness, jitter, and backpressure matter.
- Multicast/gossip: dissemination, membership, anti-entropy, or large-scale state propagation.

Best practices:

- State timeout, retry, ordering, durability, duplication, and backpressure semantics for every communication path.
- Keep synchronous dependency chains short.
- Prefer explicit state machines for workflows that cross async boundaries.
- Treat every remote call as fallible and possibly successful after timeout.

Anti-patterns:

- Local-call-style APIs over the network.
- Synchronous fan-out to many dependencies on a user request path.
- Events used as RPC without timeout/status semantics.
- Queues used as unbounded buffers for overload.

## RPC

Review prompts:

- What is the deadline?
- What does timeout mean?
- Can the server commit after the client times out?
- Are mutating calls idempotent?
- Is dedupe state durable?
- Are errors transport-level, application-level, or business decisions?
- Is the call too fine-grained?

Best practices:

- Use deadlines propagated through downstream calls.
- Use retry budgets with jitter and backoff.
- Require stable operation IDs for non-idempotent-looking mutations.
- Provide operation-status lookup for uncertain outcomes.
- Make APIs coarse enough to avoid chatty distributed object behavior.

## Messaging and Queues

Review prompts:

- Is delivery at-most-once, at-least-once, or effectively-once through dedupe?
- When is a message acknowledged?
- Is the message durable before ack?
- What is the ordering scope?
- How are poison messages handled?
- What is the dead-letter and replay policy?
- Can consumers run concurrently for the same key?

Best practices:

- Assume at-least-once delivery.
- Make consumers idempotent.
- Use outbox/inbox or equivalent patterns when state changes and messages must be atomic.
- Track oldest message age, not only depth.
- Use partition keys aligned with ordering/invariant needs.
- Define replay safety before production.

Anti-patterns:

- Ack before side effects are durable.
- Publish event before committing source state.
- Rely on global order from partitioned logs.
- Poison messages blocking unrelated work.

## Streams

Review prompts:

- Is freshness more important than completeness?
- Can late data be dropped?
- What are latency, jitter, and ordering requirements?
- How does backpressure propagate?
- Are multiple streams synchronized?

Best practices:

- Define acceptable loss, lateness, and reordering.
- Prefer bounded buffers with explicit drop/degrade policy.
- Separate control messages from bulk data where possible.
- Monitor lag by time, not only offset.

## Multicast and Gossip

Review prompts:

- Is group membership known and consistent?
- Is delivery reliable?
- Is delivery ordered?
- Is convergence probabilistic or guaranteed under assumptions?
- What is fan-out and bandwidth cost?

Best practices:

- Make duplicate handling idempotent.
- Include version/epoch metadata in disseminated state.
- Use anti-entropy repair for missed updates.
- Track convergence time and membership churn.

## Naming and Identity

Separate:

- Name: reference used by humans or systems.
- Identifier: stable identity of entity.
- Address: current location or access path.

Review prompts:

- Is identity stable across movement?
- Can names be reused?
- Are identifiers globally unique or scoped?
- Can clients confuse stale address with identity?
- What happens after delete and recreate?

Best practices:

- Do not use network address as durable identity.
- Use generation/version when names can be reused.
- Keep lookup cache TTLs explicit.
- Treat deletion/recreation as separate identity unless reuse is intentional.

## Service Discovery

Review prompts:

- Who registers service instances?
- How is health determined?
- How quickly do clients learn changes?
- What happens with stale discovery data?
- Does discovery cross regions or trust boundaries?

Best practices:

- Health checks should test semantic readiness, not only port liveness.
- Clients must tolerate stale endpoints.
- Keep discovery control plane failure from corrupting data-plane behavior.
- Emit membership and routing changes as telemetry.

## API and Schema Boundaries

Best practices:

- Version wire formats and events.
- Support mixed-version operation during rollout.
- Make backward/forward compatibility rules explicit.
- Avoid required fields that old producers cannot set or old consumers cannot ignore.
- Keep authorization context and trace IDs across async boundaries.

Anti-patterns:

- Breaking consumers with unversioned event changes.
- Encoding hidden retry/timeout behavior only in client SDKs.
- Async workers losing caller identity or authorization context.

## Review Checklist

- Communication semantics are documented.
- Mutations have idempotency strategy.
- Ordering scope is explicit.
- Backpressure is explicit.
- Discovery handles stale endpoints.
- Names, IDs, and addresses are not conflated.
- Schema evolution supports mixed versions.
- Async boundaries preserve trace, operation, and auth context.

## Test Cases

- lost request
- lost response after commit
- duplicate request
- delayed response after retry
- out-of-order messages
- poison message
- stale discovery endpoint
- service instance registers before ready
- schema old producer to new consumer
- schema new producer to old consumer
