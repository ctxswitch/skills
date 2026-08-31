# Test Review Run Format

Use this format for `.cache/test-review/<session>/`. Take the session identifier from the harness when one exists; otherwise choose a name no directory there already uses.

The directory belongs to one run. Never read, resume, overwrite, or delete another session's directory. Write each result when it is found: unstored review work is lost after compaction and can make a later deletion look justified when its surviving claim was never established.

## `run.md`

Record the run's stable frame and phase gates:

```markdown
# Test cleanup run

## Scope
- Production scope:
- Test scope:
- Excluded:
- Starting source state:
- Starting test diff:

## Commands
- Canonical test:
- Canonical coverage:
- Coverage tool and configuration:

## Baseline
- Suite result:
- Coverage report or stored artifact:
- Coverage by available dimension:
- Test files:
- Tests/cases:
- Test-code lines:
- Runtime (informational):

## Progress
- [ ] Baseline captured
- [ ] Inventory complete
- [ ] Critical coverage gaps reviewed
- [ ] Review findings stated
- [ ] Cleanup batches verified
- [ ] Survivors reviewed
- [ ] Final suite and coverage verified
- [ ] Final diff audited
```

Store the machine-readable baseline coverage report inside the session directory when the tool can emit one without changing its semantics. Otherwise record the native report path and copy the exact per-file or per-package results into `run.md`.

Tick a box only after the corresponding evidence is written. On resume, read `run.md`, then the inventory, gap, and change records before opening source or tests. Continue from the first unticked phase; do not recreate a completed phase from memory.

## `inventory.md`

Create one entry per independently meaningful test or parameterized case:

```markdown
## path/to/test.ext: test name or case
- Claim:
- Kind: behavior | boundary | seam | none | unsettled
- Production path:
- Overlaps:
- Verdict: keep | consolidate | prune: redundant | prune: pedantic | prune: dependency behavior | prune: implementation-coupled | unsettled
- Evidence:
- Survivor:
- Batch:
```

`Claim` states an observable rule owned by the repository, not what function was called. `Survivor` is required for redundant and consolidated entries. For dependency behavior, name the dependency contract being tested and the absence of local policy. For `none` or `unsettled`, explain what prevents a stronger classification.

Append entries as tests are reviewed. After all entries exist, group overlaps across files and revise verdicts in place. Mark the inventory complete in `run.md` only after every selected test has an entry and every proposed deletion has evidence.

## `gaps.md`

Create one entry per coherent cluster of uncovered production locations inspected. Record rejected candidates as well as suggestions so a resumed review does not repeatedly rediscover them.

```markdown
## path/to/source.ext: locations — owned behavior
- Coverage evidence:
- Behavior at risk:
- Consequence:
- Stable entry point or seam:
- Existing coverage:
- Verdict: suggest test | not critical | not locally owned | missing seam | unsettled
- Suggested scenario:
- Observable assertion:
- Expected coverage delta:
- Combines with:
- Evidence:
```

`Expected coverage delta` names the currently uncovered lines, branch, or function and the metric expected to increase. It is required for `suggest test`; without it, use another verdict. `Suggested scenario` and `Observable assertion` must prove behavior owned by the repository, not merely execute the uncovered location.

Group locations when one scenario should cover one behavior through one stable entry point. Do not split a coherent suggestion into line-by-line unit tests. Mark the gap review complete only after the baseline report's uncovered production regions have been classified and every suggestion has both behavioral and coverage evidence.

## `changes.md`

Create one entry per cleanup batch:

```markdown
## Batch N — owned behavior
- Inventory entries:
- Survivor or consolidated test:
- Removed or combined:
- Focused command and result:
- Coverage command and result:
- Coverage delta by available dimension:
- Covered-location delta:
- Decision: accepted | revised | reverted
- Notes:
```

An accepted batch has both kinds of evidence: the inventory shows its claims remain protected or are not locally owned, and the coverage comparison shows no decrease. Record failed attempts as revised or reverted so a resumed run does not repeat them.

## Final record

Append final coverage and footprint values to `run.md`, followed by a compact before/after comparison. Re-run the survivor audit against `inventory.md`; remove entries for deleted tests only after their mapping remains visible in `changes.md`. Summarize critical gap suggestions from `gaps.md` separately; they are proposed follow-up, not part of the cleanup coverage result.

Keep the session directory when any progress box remains unticked. After all boxes are ticked and the user-facing report has been assembled, delete the session directory; it is run memory, not repository documentation.
