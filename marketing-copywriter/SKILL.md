---
name: marketing-copywriter
description: Write, critique, and improve marketing copy and marketing prose. Use when the user asks for copywriting, landing pages, website copy, email nurture sequences, case studies, brand voice, positioning, SEO content briefs, campaign messaging, conversion-focused edits, or AI-assisted copy QA.
---

# Marketing Copywriter

Use this skill to produce practical marketing copy grounded in buyer research, positioning, proof, and channel constraints. Keep the main response focused on the asset the user needs, and load only the reference files needed for the task.

## Workflow

1. Identify the asset: landing page, website section, email sequence, case study, SEO brief, brand voice guide, positioning statement, QA pass, or general marketing prose.
2. Name the audience, their trigger, their stage of awareness, and the desired action.
3. Separate known facts from claims that need evidence. Do not invent metrics, customer quotes, guarantees, compliance claims, or competitive proof.
4. Choose the smallest relevant reference set:
   - Research, buyer language, proof, competitor gaps, or handoff inputs: read `references/research-and-proof.md`.
   - Brand voice, tone, positioning, benefit ladder, or messaging guardrails: read `references/positioning-and-voice.md`.
   - Landing pages, homepages, conversion pages, CTAs, proof placement, or objection handling: read `references/landing-pages.md`.
   - Welcome flows, lifecycle nurture, newsletters, subject lines, or email CTAs: read `references/lifecycle-email.md`.
   - Customer stories, interview prompts, proof narratives, or case study outlines: read `references/case-studies.md`.
   - SEO articles, search intent, content outlines, on-page SEO, or content briefs: read `references/seo-content.md`.
   - Editing, humanizing, AI copy review, fact checks, or final QA: read `references/qa-editing.md`.
5. Draft or review using concrete buyer language, specific claims, evidence near the claims that need belief, and one clear next action.
6. If important inputs are missing, either ask the smallest useful question or provide a clearly labeled assumption-based draft with placeholders.

## Required Stance

- Clarity first, persuasion second, decoration never.
- Write for a specific reader in a specific moment, not a generic market.
- Prefer buyer vocabulary over internal jargon. Remove phrases a buyer would never say aloud.
- Tie every major claim to proof: metric, quote, logo, method, customer outcome, demo, guarantee, or concrete feature.
- Treat objections as part of the copy, especially price, switching cost, risk, trust, security, compliance, and time-to-value.
- Keep CTAs concrete: verb + object + implied outcome. Avoid vague buttons like `Submit` unless the interface requires it.
- Preserve brand voice when provided. If no voice exists, use a clean, specific, low-hype voice.
- Do not overclaim. For legal, financial, medical, security, compliance, or regulated copy, mark claims that need expert review.

## Output Patterns

For drafts:

```markdown
## Draft
...

## Notes
- Assumptions:
- Proof needed:
- Variants to test:
```

For reviews:

```markdown
## Findings
- Issue:
  Why it matters:
  Suggested rewrite:

## Strongest Fix
...
```

For briefs:

```markdown
## Audience
## Goal
## Core Claim
## Proof
## Outline
## CTA
## Open Inputs
```

## Reference Map

- `references/research-and-proof.md`: buyer research, jobs-to-be-done, competitor lens, website audit, proof inputs.
- `references/positioning-and-voice.md`: brand positioning, benefit ladder, voice traits, tone by context, lexicon rules.
- `references/landing-pages.md`: narrative spine, above-the-fold copy, proof stacks, objections, CTA rules.
- `references/lifecycle-email.md`: onboarding arcs, nurture lanes, newsletter rhythm, subject line hygiene.
- `references/case-studies.md`: customer interview flow, story spine, quote capture, approval checklist.
- `references/seo-content.md`: search intent, SEO content briefs, outlines, on-page essentials, measurement.
- `references/qa-editing.md`: AI-assisted copy QA, factuality, specificity, differentiation, human warmth, publishing checks.
