# Self-check

The review lints a hierarchy. Nothing lints these files. Every rule here was added because a run hit a
contradiction between two rules and stopped to ask — which is an expensive way to find a cheap defect.

Run this over `SKILL.md`, `context-format.md`, `review.md`, and `sweep-format.md` when any of them
changes. It reads no repository.

## Contradiction

Two rules answering the same question differently is the defect this exists to catch. For each rule, ask
what it forbids and what it requires, then find another rule that permits or demands the opposite.

The shapes it has taken:

- A structural requirement against a conditional one — every file must carry `## Language`, versus a
  parent carries a file where something spans, which may be a fact rather than a term.
- A rule reachable only from one mode, governing something both modes do — the standard for a question
  living in the sweep's ask step, while a review asks questions too.
- A repair rule whose exemptions are enumerated rather than stated as a category, so the instance nobody
  listed becomes a question.

## Reachability

A rule that a mode cannot reach does not apply to it, whatever it says. Trace each step a mode runs and
check that every rule constraining that step is inside one of them. A standard stated in step five does
not govern step seven.

## Category, not instance

An exemption list is a bug the moment it has three entries. State what the category is and why, so the
fourth case resolves without an edit. "Splitting is not a question" left "how much to split" open;
"every Placement finding resolves from the rule" closes both and the next one.

## Duplication

The same rule stated in two files drifts, and the copy that gets edited is not always the one that gets
read. One file owns each rule; the others reference it. Deduplicate only where two statements are
identical in effect — a definition and an imperative that overlap in topic are not the same rule, and
collapsing them loses the one that was doing the work.

## Cost

A rule an agent will not follow under pressure is not a rule. Where an obligation spans many files, or
trails work rather than gating it, expect it to be batched or skipped and say so in the rule itself
rather than making the instruction more emphatic. Three rounds of stronger wording is the signal that the
shape is wrong, not the phrasing.

## Reporting

Report each contradiction as the pair of rules and the question they answer differently. A single rule
that merely reads awkwardly is not a finding.
