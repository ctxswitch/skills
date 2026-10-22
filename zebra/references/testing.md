# Testing

A test earns its place by protecting a behavior that could regress. Write the ones the change needs and stop.

## What to test

- The behavior that changed, through the public interface.
- The bug being fixed. Write the reproducing test first when practical.
- The failures you actually handled in the diff, one test each. Not the ones you declined to handle.

Do not test private helpers, call order, collaborator call counts, or input permutations that exercise no new rule.

## Mocking

Mock only at process boundaries: network, clock, filesystem, randomness, subprocesses, third-party services. Do not mock repo-owned code to expose private structure. A test that needs many internal mocks has the boundary wrong, and that is a finding, not a reason for more mocks.

Prefer a real in-process dependency when it is fast and deterministic. Prefer a small in-memory fake over a mock when behavior depends on state.

## Determinism

No real network, wall-clock sleeps, unseeded randomness, order dependence, or global state left behind. Use fake clocks, temp directories, explicit synchronization, and bounded waits.

## Failure quality

A failing test says what was expected, what was got, and with which input. Helpers mark themselves as helpers. Fixtures are small and named for the behavior.

## Reviewing tests

Flag a test that passes without exercising the behavior, asserts implementation instead of contract, is nondeterministic, or mocks what the repo owns. Flag a bug fix with no regression test. Flag a test for a branch that should not exist.
