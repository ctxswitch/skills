---
name: test-review
description: "Review and reduce an existing test suite without reducing coverage, and identify critical measured gaps that justify new tests. Use when the test footprint itself needs review: prune redundant, pedantic, implementation-coupled, and external-package tests, consolidate overlapping cases, audit every survivor, and suggest focused coverage gains. Not for diagnosing failing tests."
---

# Test Review

Review the selected suite as a set of claims the repository owns, then make it smaller and identify critical behavior it misses. Test count is not stability; a test earns its maintenance cost by protecting a distinct behavior, boundary contract, or seam.

This skill edits tests, test helpers, and fixtures for cleanup. It suggests tests for critical measured gaps but does not add them during the cleanup comparison: new coverage would conceal coverage lost by pruning. A later implementation starts from the cleaned suite's baseline and must prove the predicted increase. The skill does not change production code to make cleanup or coverage work. A source defect or a design that prevents relevant behavior from being tested is a finding, not permission to refactor the product.

Read repository instructions and the `.context.md` files covering the scope before judging its tests. Use the project's language for the behavior it owns.

## Guard against the default

The default failure mode is preserving or replacing tests merely because more tests feel safer.

- **Coverage is a gate and a locator, not a purpose.** Equal coverage is necessary before a test can be removed, but it does not prove that two tests protect the same behavior. Uncovered locations identify candidates, but only a critical locally owned behavior justifies a new test.
- **Do not replace footprint with footprint.** Never add a test solely to compensate for a deleted test or touch an otherwise uncovered line. A replacement or consolidation must state the locally owned claim it protects.
- **Do not suggest coverage-neutral tests.** Every suggested test names the currently uncovered lines, branch, or function it should exercise and the metric it should increase. If it cannot predict a measurable gain, it is not a suggestion from this review.
- **Do not reward exhaustive permutations.** Two inputs deserve separate cases only when they exercise different rules, branches, risk classes, or externally visible outcomes.
- **Do not test a dependency on its behalf.** Keep a boundary test when it proves this repository's configuration, translation, error mapping, compatibility decision, or use of the dependency. Remove a test whose only claim is that the language, framework, or package behaves as its own contract says.
- **Do not preserve implementation surveillance.** Assertions about private helpers, internal call order, collaborator call counts, or incidental representation survive only when that detail is itself a local contract.
- **Do not chase a reduction target.** If no test can be removed or consolidated under these rules, a clean review with no edits is the correct result.

Old regression tests are not exempt and small tests are not suspect by default. Keep a regression test when it names a distinct failure the public behavior could reintroduce. Keep a small edge case when the edge is a real rule. History, size, and coverage alone settle neither decision.

## Track the run

Before reading the tests in detail, create `.cache/test-review/<session>/` and follow [run-format.md](./references/run-format.md). The run directory is working memory: record findings as they are made, resume only the current session from it, and delete it only after every closing check passes.

The review pass finishes before the first edit. It covers both existing tests and critical uncovered production paths. Redundancy is a relationship across the suite; pruning while still discovering tests lets the order of discovery decide which test survives.

## 1. Scope and baseline

Define the production behavior and test directories in scope. Exclude generated, vendored, and dependency-owned suites unless the user explicitly included them.

Find the canonical test and coverage commands from repository instructions, CI, build files, and existing tooling. Use the same command, flags, environment, package set, and coverage configuration for baseline and final measurement. Do not substitute a narrower final command.

Before changing anything:

1. Record the existing worktree state so user changes are not mistaken for cleanup edits.
2. Run the canonical suite and require it to pass.
3. Capture coverage at the finest granularity the tool exposes. Prefer exact covered locations; otherwise record every available metric per file or package, not only the repository-wide percentage.
4. Record the footprint: test files, tests or cases where the framework can enumerate them, and test-code lines excluding generated files and fixtures. Record runtime as context, not as a correctness gate.

If the suite is red or a coverage baseline cannot be measured, stop without editing and report the blocker. If production source or coverage configuration changes during the run, the comparison is invalid; establish a new baseline against the new source state before continuing.

## 2. Review the whole suite

Read the production path, tests, helpers, and fixtures for each behavior in scope. Group tests by owned claim rather than by filename. For every test or independently reported parameterized case, record:

- the observable claim it protects;
- whether the claim is a behavior, boundary contract, or seam;
- the production path it exercises;
- which other tests overlap it;
- the proposed verdict and concrete evidence for that verdict.

Use these verdicts:

- **Keep** — it protects a distinct locally owned claim.
- **Consolidate** — several cases protect one claim and can share setup and action without hiding materially different failures.
- **Prune: redundant** — another test protects the same claim under the same meaningful conditions, with assertions at least as strong.
- **Prune: pedantic** — it varies a literal or inspects a detail without reaching a different rule, branch, risk class, or outcome owned here.
- **Prune: dependency behavior** — it proves only an external package's contract and no local policy at the boundary.
- **Prune: implementation-coupled** — it observes internals without protecting an externally meaningful result or an intentional seam contract.
- **Unsettled** — the distinct claim or overlap cannot yet be established. An unsettled test is not a deletion candidate.

A parameterized or table-driven test is not automatically consolidated. Combine cases when they are examples of one rule and retain case-level failure identification. Keep separate tests when combining them would mix contracts, obscure the failed behavior, or prevent independent setup and assertions.

## 3. Identify critical coverage gaps

Use the baseline report to inspect uncovered statements, branches, and functions in the production scope. Group nearby uncovered locations by the behavior that reaches them, then read the source and existing tests. Coverage locates the gap; it does not determine its importance.

A gap justifies a test suggestion only when all of these hold:

- the path is reachable and owned by this repository;
- the missed path carries a materially different behavior, boundary contract, or seam;
- failure there has a concrete consequence, such as broken authorization, corrupted or lost data, an invalid state transition, incorrect ordering or idempotency, failed recovery, or wrong translation at an external boundary;
- a test can reach it through a stable interface and assert an observable result;
- the test is expected to increase a named coverage metric at specific currently uncovered locations.

Do not promote uncovered logging, generated code, dependency internals, trivial forwarding, impossible defensive branches, or input permutations with no new rule. Do not suggest a private-method test or mock choreography when no stable seam exposes the behavior; record the missing seam as a design finding.

For each critical gap, record the coverage evidence, local behavior at risk, expected coverage delta, and one focused test scenario with its entry point and observable assertion. Prefer one behavior test that closes a coherent cluster over one unit test per uncovered line. If the expected delta cannot be named, do not suggest the test.

When the test inventory and gap review are complete, state the proposed cleanup size and categories, then list critical gap suggestions separately. If the user requested review only, stop there; otherwise proceed without turning the summary into an approval gate.

## 4. Consolidate and prune

Work in small behavior-level batches. Each batch names the surviving test or consolidated replacement and maps every removed case to the claim that still protects it.

Consolidate overlapping setup and examples first, then remove tests whose claims are already represented. Prefer the clearest existing behavior test as the survivor; do not keep a weaker test merely because it appeared first. Test helpers may be simplified or deleted when the remaining suite no longer needs them.

After each batch:

1. Run the focused tests.
2. Run the canonical coverage command.
3. Compare against the baseline at the same granularity.
4. Record the edit, commands, and comparison in the run directory.

If any covered location or reported coverage dimension decreases, revise the batch until it is restored. Do not average away a loss in one file or metric with a gain elsewhere. A batch that preserves coverage can still be wrong; retain it only when the claim inventory also shows that no locally owned behavior was lost.

Do not mix production refactors, unrelated test improvements, or suggested gap tests into the cleanup. They make the baseline incomparable and conceal what each deletion did. Finish cleanup against its original baseline before starting any coverage additions from a new baseline.

## 5. Review the survivors

Run a second review over every remaining test in scope. Each must have one concrete answer to: *what locally owned behavior, boundary contract, or seam would regress without this test?*

Revisit any survivors with the same answer. Consolidate further where one readable test can preserve the claim and identify failures clearly. Do not combine unrelated behaviors just to reduce the count.

## 6. Close

Completion requires all of the following:

- the original canonical suite passes;
- final coverage uses the baseline command and source state;
- no covered location or available file/package coverage metric decreased;
- every remaining test has a distinct recorded claim;
- every removed test maps to a surviving claim or to behavior the repository does not own;
- every suggested test maps to a critical locally owned behavior and predicts a gain at named uncovered locations;
- the diff is limited to tests, test helpers, and fixtures in scope;
- test footprint decreased, unless the review found no valid cleanup.

Report the before/after footprint, exact coverage comparison, tests consolidated and pruned by category, critical gaps and their focused test suggestions, commands run, and anything unsettled. Keep suggested additions separate from completed cleanup. Report coverage dimensions the tooling could not measure as limitations rather than silently treating them as preserved.

Once the report can be rebuilt from the completed run records, delete only this session's `.cache/test-review/<session>/` directory. Leave it in place when the run is interrupted or any closing check fails.
