# Behavior-Focused Tests

Use this reference when choosing test boundaries or reviewing test quality.

## Good Tests

Good tests read like capability specifications:

- exercise real code paths through public or stable interfaces
- verify behavior that users, callers, or operators care about
- survive internal refactors
- avoid private methods and incidental call structure
- fail when behavior changes, not when implementation is reorganized

Examples of good test targets:

- an HTTP request returns the expected status and body
- a command handler persists a domain change visible through a query path
- a package export accepts input and returns a documented result
- a worker processes a message idempotently
- a CLI command writes the expected file or output

## Poor Tests

Poor tests are coupled to implementation details:

- private methods
- internal helper calls
- call counts for collaborators the repo owns
- internal data structures that callers cannot observe
- direct database inspection when a domain query interface exists
- fragile snapshots of incidental formatting

Warning sign: the test fails after a behavior-preserving refactor.

## Test Selection

Prioritize:

- critical user workflows
- bug reproductions
- invariants
- complex branching
- boundary and error handling
- integration points

Avoid trying to exhaustively test every edge case before the first implementation. Add cases as the design and risk become clearer.

## Test Names

Prefer names like:

- `creates invoice after fulfillment is confirmed`
- `returns existing operation result when retry uses same idempotency key`
- `rejects checkout when cart total changed after quote`

Avoid names like:

- `calls createInvoice`
- `sets status field`
- `uses repository mock`

## Characterization Tests

Use characterization tests before refactoring legacy code when behavior is unclear but must be preserved.

Characterization tests should:

- describe current observable behavior
- cover known risky paths
- avoid freezing accidental internals
- be renamed or replaced once the intended behavior is understood
