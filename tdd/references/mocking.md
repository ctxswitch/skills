# Mocking And Test Doubles

Use this before introducing mocks, fakes, stubs, or dependency injection.

## Mock System Boundaries

Mock or fake boundaries that are outside the unit of ownership:

- external APIs
- payment, email, storage, queue, or SaaS providers
- time and randomness
- filesystem or network where real usage is slow or unsafe
- hard-to-trigger boundary failures

Prefer real in-process dependencies for code owned by the repo when they are fast and deterministic.

## Avoid Mocking Internals

Do not mock:

- private methods
- internal collaborators owned by the same module
- repositories or services only to assert call counts
- data mappers or helper functions that are implementation details

If a test needs many internal mocks, the interface is probably too shallow or the behavior boundary is wrong.

## Prefer Fakes For Stateful Boundaries

Use an in-memory fake when behavior depends on state and the real dependency is external or expensive.

Good fakes:

- implement the same boundary contract
- are small and deterministic
- model only behavior the tests rely on
- expose no test-only internals unless absolutely necessary

Bad fakes:

- duplicate production logic
- require conditional behavior per test
- return impossible states
- become more complex than the boundary

## Dependency Injection

Accept boundary dependencies at construction or call time when doing so makes external effects explicit.

Keep injection at meaningful seams. Do not pass every helper as a dependency just to make private code mockable.

## SDK-Style Boundaries

For external services, prefer specific boundary methods over a generic fetch function:

- `GetUser(ctx, id)`
- `CreateOrder(ctx, input)`
- `SendInvoice(ctx, invoiceID)`

Specific methods keep tests clear, type-safe, and free of conditional mock logic.
