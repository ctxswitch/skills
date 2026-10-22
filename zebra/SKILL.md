---
name: zebra
description: "Write or review production code in Go, Python, Rust, TypeScript/React, or Protocol Buffers with the common failure modes handled well and the rare ones detected, not handled. Use for implementing a known change or reviewing a diff when simplicity matters more than coverage of every case. Not for a bug whose cause is still unknown (diagnose)."
---

# Zebra

Named after Bryan Cantrill's *Zebras All the Way Down*. Rare failures do happen in production. The answer is not to pre-handle every one: code written for a zebra nobody has seen has never run, and it fails unpredictably when the zebra arrives. Every speculative branch is a new place for a zebra to live.

Handle the horses well. Make the zebras loud. Keep the system small enough to debug when one shows up.

## Default: add nothing

Write the requested behavior and nothing else. No branch, check, helper, parameter, type, comment, log line, TODO, or test beyond it. The exception is in the next section, and it is narrow.

Detection is usually no code. The natural failure, the exception, the panic, the error return already there, is the detection. Add a check only when the natural failure would be silent, producing a wrong value instead of an error, or would surface far from the cause. A check you add raises or returns. It never logs and continues, and never substitutes a value.

These are speculative handling in another form and get the same treatment:

- A TODO or comment naming a failure you decided not to handle. Delete it. The decision goes in the PR body, not the code.
- A log line that is not on an error return.
- A docstring or comment in a file whose comparable functions have none.
- A new error type with one raise site.
- A parameter, alias, or accepted shape kept for a caller that does not exist.
- A defensive copy, a `Debug`, `Display`, or `__repr__` impl, or a type guard that nothing reads.

If you would describe a line as "for safety", "defensive", "robust", "graceful", or "just in case", it is speculative. Delete it.

## The exception: evidenced failures

A failure is evidenced when one of these holds, in descending order of strength:

1. **The repo names it.** A regression test, an incident reference, or a comment explaining an existing guard.
2. **A reachable neighbor guards the same state.** A sibling or caller handles it, and that guard has a test, a comment naming the cause, or a producer you can point to. If the caller already guards it, do not guard again.
3. **The diff itself makes the call that produces it.** A network, file, subprocess, or database call on a line you added can fail or hang. The single point where bytes are parsed into a type can receive absent or malformed input. An acquire you added needs its release on the error path. Only the line in the diff that makes the call counts. A value that arrived from a boundary somewhere else is trusted here. Parse once at the entry, then trust inward.

A failure you can describe but cannot evidence is speculative, however plausible it sounds. Handle every evidenced failure on a line the diff adds or changes, in the shape the surrounding code uses, and stop. A pre-existing unhandled failure on a line you did not change goes in the report under unrelated issues, not in the diff.

## Speculative failures

Everything without evidence gets detected, not handled.

- **Name the failure and its path before writing a branch for it.** If you cannot say how the code reaches that state here, do not handle it. "In principle" is not a path.
- **Detect, do not recover.** Let the natural failure happen, or return the error, or halt. No fallback value, repair routine, or degraded mode for a state the caller cannot produce. A halt with a clear message is debuggable. A silent recovery is not.
- **No resilience machinery unprompted.** Retry, backoff, caching, pooling, rate limiting, circuit breaking, feature flags. Each is a policy with its own failure modes. Add one only when the change names the failure it covers and that failure has occurred. If the request names machinery without the failure, ask once which failure, then build it. Never add machinery the request did not name.
- **One caller, no abstraction.** One implementation needs no interface. One instantiation needs no type parameter. One consumer needs no registry, factory, or strategy. One call site needs no option or parameter.
- **Constants stay constants** until something configures them.
- **No helper for a name's sake.** Extract only to remove duplication that exists in the diff or the file. Length, readability, and single responsibility are not reasons. A helper with one caller is inlined.

## Working rules

- **Keep edits narrow.** Match surrounding style and names. Do not refactor, rename, or improve unrelated code. Matching style does not mean copying a neighbor's speculative checks.
- **Verify specifics before asserting them.** Signatures, fields, flags, config keys, error types, versions. Read the definition first. A helper mentioned in the prompt is a claim, not a fact.

## References

Load only for the languages the change touches. Each lists the failures that occur in that language when the obvious code is written and nothing is added. Nothing else in the language is evidenced by construction.

- Go: `references/go.md`
- Python: `references/python.md`
- Rust: `references/rust.md`
- TypeScript, React: `references/typescript.md`
- Protocol Buffers, gRPC, ConnectRPC: `references/proto.md`
- Tests in any language: `references/testing.md`

## Reviewing

Same rules, applied to someone else's diff. Direct, evidence-based, no praise, no edits. Read the whole diff before writing a finding: speculative handling in one file often covers an evidenced failure missed in another.

Three passes, in order.

### Pass 1: evidenced failures

Inventory every I/O call, parse point, and acquire on lines the diff adds or changes. For each, check that its failure is handled, handled once, and handled in the shape the surrounding code uses. Then read the tests, comments, and neighboring guards the diff sits among for failures the repo names.

The decidable misses: an I/O call with no error check or timeout, an acquire with no release on the error path, an error swallowed or replaced with a default.

A finding that asks for handling must cite the test, comment, neighbor guard, or boundary call in the diff that evidences it. "Could be" is not a finding. A miss here is a failure that will happen.

### Pass 2: speculative handling

Walk every branch, parameter, type, layer, dependency, comment, log line, and test the diff adds. Demand the real failure or real caller each one serves.

- A branch for a state the caller cannot produce. Ask for the path.
- A recovery, fallback, default, or repair routine where the natural failure, a returned error, or a halt would do. The most common form and the most dangerous: it has never run, and it hides the failure it was written for.
- Retry, backoff, caching, pooling, rate limiting, circuit breaking, or a feature flag the change did not ask for and no incident motivated.
- An interface, generic, registry, factory, strategy, or injection point with one implementation.
- A parameter, option, or config value with one call site or one value.
- A helper called once, a wrapper that forwards, a layer that renames its inputs and passes them on.
- A dependency for something the standard library or an existing dependency already does.
- A defensive check that duplicates one the type system, the caller, or an earlier boundary already made.
- A TODO naming an unhandled failure, a log line off the error path, a comment in an uncommented file, an error type with one raise site, a test for a branch that should not exist.

Each is a finding, not a nit. Name the concrete consequence: a branch that fails untested when it finally runs, a failure hidden until it compounds, a policy that binds every future caller, or a surface the next reader must understand and the next change must preserve.

### Pass 3: scope

Compare the diff to the change described. Unrelated refactors, renames, reformatting, improved comments, and moved code are unjustified until the PR body explains them. If it does not, the addition itself is the finding.

### What not to flag

- Absent handling for a failure with no evidence under the three criteria.
- The repo's established framework, runtime, error strategy, test runner, formatter, or layout.
- A missing abstraction when the concrete code is simpler and has one caller.
- Duplication small enough that removing it would cost a layer.
- A long function where the alternative is indirection that hides more than it saves.
- An optimization not taken, absent a measured or obviously reachable cost.

Never propose an abstraction, layer, pattern, or configuration knob as an improvement in itself. A suggestion that makes the code bigger must name what breaks without it, on a path the code reaches.

### Findings

Each finding carries file, line, pass, severity, the concrete failure or cost, and its consequence. Not how you found it.

Severity follows consequence, not pass.

- **Blocks.** A failure the code reaches on a real path: an evidenced failure unhandled, a leak, a hidden error, a wrong result, a hang. Speculative handling that conceals one of these blocks too. Not merged until fixed.
- **Fix before merge.** Speculative handling or scope excess with a cost the reader will pay. Merges once removed, or once the author names the real failure or caller it serves. A small diff with several once-called helpers yields several of these. That is intended.
- **Note.** Real enough to record, too small to hold the change for. Rare. If a finding would be a note, ask whether it is a finding at all.

Order by severity, then pass. A no-findings verdict lists each I/O call, parse point, and acquire in the diff and how each is handled. That is the evidence Pass 1 ran. Name any validation not run.

## Before reporting

List every branch, check, helper, parameter, type, comment, log line, and test you added. Beside each, write the evidence line from the exception section that justifies it. Delete any without one. Report what you deleted and why, so the reasoning is visible and can be overruled.

Then report files changed, assumptions worth review, unrelated issues noticed including pre-existing unhandled failures you did not touch, and validation status including anything not run.
