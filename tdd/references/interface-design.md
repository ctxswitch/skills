# Interface Design For Testability

Use this when behavior is difficult to test through the current interface.

## Principles

Good interfaces make the right tests natural:

- callers can express one meaningful operation
- inputs are explicit and cohesive
- outputs or state changes are observable through stable seams
- external dependencies are visible at boundaries
- internal sequencing stays hidden

## Prefer Observable Results

Return useful results or expose a query path instead of forcing tests to inspect internals.

Examples:

- command returns an operation ID that can be queried
- write path makes state visible through the same read interface users use
- handler returns a domain result rather than only mutating hidden fields

## Keep Side Effects At Boundaries

Separate pure domain decisions from external effects when it clarifies behavior:

- compute decision in domain code
- persist through repository or store boundary
- send external effects through an outbox, client, or adapter

Do not split code only for artificial unit tests. Split when the boundary matches a real responsibility.

## Reduce Test Setup

If every test needs a large object graph, ask:

- Is the public operation too small?
- Are callers forced to orchestrate internal steps?
- Does a module need to become deeper?
- Is dependency injection happening too low in the call stack?

## Interface Review Questions

- What behavior should a caller be able to rely on?
- What details should callers not know?
- What is the smallest stable surface that proves the behavior?
- Which dependencies are true external boundaries?
- Which tests would survive a complete internal rewrite?
