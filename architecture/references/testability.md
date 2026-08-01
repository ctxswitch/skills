# Designing For Testability

Use when behavior is hard to test through the current interface. Assumes [language.md](./language.md); the testing strategy for a deepened module lives in [deepening.md](./deepening.md).

The failure this guards against: reaching for a mock or a private-structure assertion when the real problem is that the interface does not expose the outcome.

## Prefer observable results

Return a useful result or expose a query path instead of forcing tests to inspect internals:

- command returns an operation ID that can be queried
- write path makes state visible through the same read interface users use
- handler returns a domain result rather than only mutating hidden fields

## Keep side effects at boundaries

Separate pure domain decisions from external effects *when it clarifies behavior*:

- compute decision in domain code
- persist through repository or store boundary
- send external effects through an outbox, client, or adapter

Do not split code only to enable artificial unit tests. Split when the boundary matches a real responsibility. Extracting a pure function purely for testability, while the real bugs live in how it is called, moves the code without moving the risk.

## Reduce test setup

If every test needs a large object graph, ask:

- Is the public operation too small?
- Are callers forced to orchestrate internal steps?
- Does a module need to become deeper?
- Is dependency injection happening too low in the call stack?

## Interface review questions

- What behavior should a caller be able to rely on?
- What details should callers not know?
- What is the smallest stable surface that proves the behavior?
- Which dependencies are true external boundaries?
