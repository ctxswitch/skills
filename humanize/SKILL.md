---
name: humanize
description: Use this when the user asks to humanize, naturalize, de-bot, de-AI, soften, rewrite, or polish prose so it sounds like a real person wrote it. Applies to emails, docs, posts, essays, marketing copy, support replies, status updates, proposals, and other written documents. Focus on reducing botlike phrasing, stiff structure, generic filler, and unnatural punctuation while preserving the author's meaning, facts, intent, and appropriate voice.
---

# Humanize

## Core Rule

Revise the writing so it sounds natural, specific, and human without making it sloppy or changing what it means. Do not add facts, claims, citations, personal experiences, or emotional stakes that are not already supported by the text or user context.

## Workflow

1. Identify the audience, format, and likely voice from the document and user request.
2. Preserve all concrete facts, names, numbers, dates, requirements, and commitments.
3. Rewrite botlike passages instead of only swapping words.
4. Tighten or vary sentence structure where the prose feels templated.
5. Normalize punctuation so it fits the voice and medium.
6. Return the revised text first unless the user asks for notes, diffs, or explanation.

## What To Fix

- Generic AI transitions: "Furthermore", "Moreover", "It is important to note", "In today's fast-paced world", "Ultimately", "Delve", "Leverage", "Robust", "Seamless", "Comprehensive", "Game-changing".
- Over-explaining: remove throat-clearing, redundant setup, obvious caveats, and repeated conclusions.
- Symmetric paragraph formulas: vary rhythm when every paragraph follows the same setup-example-takeaway pattern.
- Over-polished tone: make it sound like a capable person, not a corporate template.
- Hedging or certainty mismatches: keep confidence aligned with the source text.
- Forced enthusiasm: remove excessive praise, hype, and exclamation points unless the format calls for it.
- Punctuation tells: reduce overused em dashes, semicolons, colons, parentheses, scare quotes, and stacked commas when they make the prose feel machine-generated.

## Punctuation Guidance

Do not ban any punctuation mark globally. Use punctuation based on the voice and medium.

- Replace some em dashes with commas, periods, parentheses, or separate sentences when they appear too often.
- Prefer periods over long compound sentences when the draft feels breathless.
- Keep contractions when they fit the speaker and audience.
- Avoid perfectly balanced three-part lists when they sound formulaic.
- Preserve technical punctuation, legal language, citations, code, commands, and quoted text unless asked to edit them.

## Voice Controls

When the user gives a tone, follow it. If not, choose a clean, direct, adult voice:

- Emails: clear, warm, and concise.
- Internal docs: practical and plain.
- Executive writing: direct, specific, and low-fluff.
- Marketing copy: vivid but believable.
- Academic or formal writing: natural but still appropriately formal.
- Personal writing: conversational without sounding careless.

## Output Format

Default to only the revised document. If the original is long or the user asks for review, include a short note after the revision with the main changes made.

If a requested rewrite would misrepresent authorship, fabricate lived experience, hide required disclosure, or evade a detection/assessment system, decline that part and offer a transparent revision focused on clarity and natural style.
