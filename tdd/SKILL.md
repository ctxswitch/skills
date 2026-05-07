---
name: tdd
description: "Use TDD, test-first, red-green-refactor, reproducing tests, integration tests, characterization tests, and behavior-focused tests for features, bugs, refactors, and behavior changes."
---

# Test-Driven Development

Use this skill to implement changes through a tight red-green-refactor loop. Tests should describe observable behavior through stable public interfaces, not private structure.

## Core Rule

Work vertically:

```text
RED: one failing behavior test
GREEN: minimal code to pass that test
REFACTOR: improve design while tests stay green
```

Do not write all tests first and then all implementation. Each test should respond to what the previous cycle taught.

## Workflow

1. Inspect the existing test style, public interfaces, domain docs, and relevant ADRs.
2. Identify the smallest user-visible or caller-visible behavior to prove first.
3. Add one failing test. Run it and confirm it fails for the expected reason.
4. Implement the smallest change that makes that test pass.
5. Run the focused test. Fix only what is needed.
6. Repeat for the next behavior.
7. Refactor only while green.
8. Run the affected package/suite and report the result.

For bug fixes, start with a reproducing test that fails before changing production code.

For refactors, add characterization tests first if existing coverage does not protect the behavior.

## Test Standards

- Prefer integration-style tests through public APIs, command handlers, HTTP endpoints, package exports, or other stable seams.
- Name tests after behavior, not internal steps.
- Mock only system boundaries: external services, time, randomness, filesystem, network, or hard-to-trigger boundary failures.
- Do not mock code owned by the repo just to make private structure visible.
- Avoid asserting call counts/order unless the ordering is itself observable behavior.
- Keep tests deterministic: no arbitrary sleeps, real network, unbounded time, shared global state leaks, or uncontrolled randomness.

## Planning With The User

If the public interface or desired behavior is ambiguous, ask before editing:

```markdown
Which public interface should this behavior appear through, and which behavior should the first failing test prove?
```

If the behavior is clear from the issue, existing tests, or code, proceed without asking.

## Loading Rule

- Read `references/tests.md` when deciding what to test or reviewing test quality.
- Read `references/mocking.md` before introducing mocks, fakes, stubs, or dependency injection.
- Read `references/refactoring.md` before refactoring after green tests.
- Read `references/interface-design.md` when the current interface makes behavior hard to test.
- Read `references/deep-modules.md` when TDD reveals shallow modules or scattered complexity.

## Cycle Checklist

```markdown
- [ ] Test describes observable behavior.
- [ ] Test uses a stable public interface or boundary seam.
- [ ] Failure was observed before implementation.
- [ ] Production code is minimal for the current behavior.
- [ ] Refactor happened only while green.
- [ ] Focused tests pass.
```
