# QA and Editing

Use this for polishing marketing copy, reviewing AI-assisted drafts, humanizing generic prose, checking claims, and preparing copy for publication.

## Table of Contents

- QA method
- Claim checks
- Specificity checks
- Differentiation checks
- Voice checks
- Conversion checks
- AI-assisted copy checks
- Sensitive claims
- Rewrite patterns
- Review rubric
- Output templates

## QA Method

1. Identify the asset and desired action.
2. Read once for reader clarity.
3. Read once for claims and proof.
4. Read once for differentiation.
5. Read once for voice and tone.
6. Read once for conversion path.
7. Mark claims that need SME, legal, compliance, or customer approval.
8. Provide the smallest rewrite that fixes the highest-impact issue first.

Best practices:

- Preserve true, specific substance.
- Cut filler before rewriting style.
- Separate missing proof from weak prose.
- Rewrite around reader context, not just nicer phrasing.
- Keep useful constraints visible.

Anti-patterns:

- Polishing unsupported claims.
- Making copy warmer but less clear.
- Replacing jargon with vague friendliness.
- Turning every sentence into a marketing sentence.
- Removing caveats that protect trust.

## Claim Checks

For every important claim:

- What exactly is being promised?
- Who does it apply to?
- Under what conditions?
- What proof supports it?
- Is the claim comparative?
- Does it imply a guarantee?
- Does it need review?

Claim categories:

- **Product fact**: feature, integration, pricing, availability.
- **Performance claim**: faster, cheaper, more accurate, higher conversion.
- **Trust claim**: secure, compliant, reliable, enterprise-ready.
- **Outcome claim**: revenue, productivity, retention, savings.
- **Comparative claim**: better than competitor, best, leading, first.

Claim rewrite rules:

- If proof exists, make the claim specific.
- If proof is weak, soften the claim or move it to a hypothesis.
- If proof is missing, mark it.
- If claim is regulated, flag for review.

## Specificity Checks

Generic copy often lacks:

- concrete nouns
- named audience
- mechanism
- timeframe
- examples
- before/after contrast
- visible tradeoff
- proof
- next action

Specificity upgrades:

```markdown
Generic: Save time with automated workflows.
Specific: Close weekly pipeline reviews without chasing five exports.

Generic: Improve collaboration.
Specific: Give sales, finance, and ops the same renewal view before forecast calls.

Generic: Reduce risk.
Specific: Catch missing approvals before contracts reach signature.
```

Specificity warning:

- Do not invent numbers or scenarios. Use placeholders when details are missing.

## Differentiation Checks

Ask:

- Could a competitor paste their name into this copy?
- Does the copy name a mechanism, method, constraint, or belief?
- Does it show the tradeoff the brand chose?
- Does the proof support the differentiated claim?
- Is the category clear enough for the differentiation to matter?

Differentiation sources:

- unique process
- specific audience focus
- speed with caveat
- integration depth
- operating model
- customer proof
- expertise
- pricing model
- implementation approach
- product constraint that benefits the buyer

Weak differentiators:

- innovative
- customer-first
- seamless
- robust
- end-to-end
- all-in-one
- trusted by teams

These can be used only when supported by details that make them concrete.

## Voice Checks

Check:

- Does it match known brand examples?
- Does tone fit the context?
- Are voice traits visible in actual sentence choices?
- Does the copy avoid banned phrases?
- Is humor appropriate to the reader's risk?
- Is the copy too polished to sound credible?

Voice repair:

- Keep buyer nouns.
- Reduce generic enthusiasm.
- Use contractions if brand voice supports them.
- Prefer strong verbs over inflated adjectives.
- Vary sentence length without becoming chatty.
- Keep technical terms when they are buyer language.

## Conversion Checks

Ask:

- Is the next action clear?
- Is the CTA appropriate to stage?
- Does the copy answer the objection before the CTA?
- Is the form/button microcopy reassuring?
- Does the reader know what happens after clicking?
- Is there a lower-friction path for qualified hesitation?

CTA repair:

- Replace vague verb with concrete action.
- Add object.
- Add expectation-setting microcopy where needed.

Example:

```markdown
Weak: Submit
Better: Get the checklist
Microcopy: Sent by email. No sales call required.
```

## AI-Assisted Copy Checks

Model-output smells:

- "In today's fast-paced world"
- "unlock"
- "leverage"
- "seamless"
- "robust"
- "game-changing"
- "whether you're X or Y"
- perfectly balanced three-part lists
- summary paragraphs that restate instead of adding
- generic warmth with no buyer context

Where AI helps:

- angle generation
- variant generation
- simplification
- summarization of approved inputs
- outline alternatives

Where humans must lead:

- positioning
- promises
- guarantees
- customer quotes
- proof selection
- sensitive claims
- final judgment

## Sensitive Claims

Flag:

- medical outcomes
- financial returns
- legal compliance
- security guarantees
- privacy claims
- regulated industry claims
- competitor superiority
- customer metrics
- testimonials
- AI capability claims

Safe handling:

- Mark as needs review.
- Avoid absolute wording.
- Use approved language when available.
- Include caveats.
- Do not imply guarantee unless approved.

## Rewrite Patterns

Claim/proof rewrite:

```markdown
Original:
Issue:
Proof available:
Rewrite:
Proof still needed:
```

Feature-to-benefit rewrite:

```markdown
Feature:
Reader task:
Workflow consequence:
Benefit:
Proof:
```

Voice rewrite:

```markdown
Off-brand:
Why:
On-brand:
```

## Review Rubric

Score 0-2:

- Factuality
- Specificity
- Differentiation
- Reader fit
- Voice fit
- Proof proximity
- Objection handling
- CTA clarity
- Compliance risk
- Skimmability

Rubric interpretation:

- 0: missing or risky
- 1: present but weak
- 2: strong enough to publish or test

## Common Findings

Unsupported claim:

- Evidence: strong promise has no proof.
- Fix: add proof, soften, or mark for review.

Generic AI tone:

- Evidence: boilerplate phrases and no buyer context.
- Fix: restore specific reader, task, and mechanism.

Differentiation gap:

- Evidence: competitor could reuse copy.
- Fix: add method, constraint, proof, or audience focus.

CTA ambiguity:

- Evidence: unclear what happens next.
- Fix: verb + object + expectation.

Over-polished quote:

- Evidence: quote sounds like company copy.
- Fix: shorten and make conversational while preserving approval.

## Output Templates

Review:

```markdown
## Biggest Issues
- Claim/proof:
- Clarity:
- Differentiation:
- Voice:
- CTA:
- Compliance:

## Rewrite

## Proof Needed

## Optional Variants
```

Publish checklist:

```markdown
- [ ] Claims checked
- [ ] Proof placed near claim
- [ ] CTA clear
- [ ] Voice aligned
- [ ] Objections handled
- [ ] Sensitive claims reviewed
- [ ] Links and microcopy checked
```
