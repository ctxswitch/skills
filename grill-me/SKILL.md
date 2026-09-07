---
name: grill-me
description: "Interrogate a plan against the project's own domain language and recorded decisions, sharpening terminology as answers land. Use when the plan's vocabulary or its fit with documented decisions is what needs testing. For correctness under failure, use distributed-systems."
---

# Grill Me

Press on unresolved decisions and their consequences until the design is settled.
Walk down the branches of the design tree that can change the plan, implementation, domain language, or documentation.
For each question, provide your recommended answer.
Ask the questions one at a time, waiting for feedback on each question before continuing.
If a question can be answered by exploring the codebase, explore the codebase instead.
Do not ask a question if the answer is already stated, directly implied by prior answers, or discoverable from local code/docs. If the answer is discoverable, inspect first and ask only to resolve a contradiction or missing decision.
Continue while the next question exposes a real unresolved decision, contradiction, risk, or implementation consequence. When the next question would only restate known tradeoffs or ask for preference without consequence, summarize what is resolved and identify the next concrete action.

## During the session

### Challenge established usage

When the user uses a term that conflicts with how the codebase and its docs already use it, call it out immediately.

"The code names this 'cancellation' for X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term only if the ambiguity could lead to different code, ownership, user behavior, operational behavior, tests, or documentation.

"You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios.
Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees.

If you find a contradiction, surface it:

"Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"
