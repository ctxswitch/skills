# CONTEXT.md Format

## Structure

```md
# {Scope Name}

{One or two sentence description of what this scope covers and why it exists.}

## Language

**Order**: {A concise description of the term}
_Avoid_: Purchase, transaction

**Invoice**: A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**: A person or organization that places orders.
_Avoid_: Client, buyer, account

## Relationships

- An **Order** produces one or more **Invoices**
- An **Invoice** belongs to exactly one **Customer**

## Example dialogue

> **Dev:** "When a **Customer** places an **Order**, do we create the **Invoice** immediately?"
> **Domain expert:** "No — an **Invoice** is only generated once a **Fulfillment** is confirmed."

## Flagged ambiguities

- "account" was used to mean both **Customer** and **User** — resolved: these are distinct concepts.
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others as aliases to avoid.
- **Flag conflicts explicitly.** If a term is used ambiguously, call it out in "Flagged ambiguities" with a clear resolution.
- **Keep definitions tight.** One sentence max. Define what it IS, not what it does.
- **Show relationships.** Use bold term names and express cardinality where obvious.
- **Only include terms specific to this project's context.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively. Before adding a term, ask: is this a concept unique to this context, or a general programming concept? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.
- **Write an example dialogue.** A conversation between a dev and a domain expert that demonstrates how the terms interact naturally and clarifies boundaries between related concepts.

## Scope

Context files form a hierarchy. Each directory that owns language carries one, describing only what is true at its own level.

**A fact belongs at the shallowest directory where it holds for everything beneath it, and no shallower.**

```
CONTEXT.md                          the product — what it is, who uses it
services/CONTEXT.md                 the services and what each is for
services/billing/CONTEXT.md         the billing domain
services/billing/ledger/CONTEXT.md  the ledger's own terms
```

A reader loads the root file down to the directory being worked in, and every level assumes its ancestors. Nothing is repeated from a parent.

A directory owning nothing at its own level carries no file and inherits from its parent. `internal/util` stays empty rather than padded.

A directory holding documents rather than code owns no scope. `docs/` and its subtrees never carry a `CONTEXT.md` — a document is context already, and the language it uses belongs with the code it describes.

### Misplacement

- **Over-scoped** — the file states something untrue of part of its subtree. Move it down to where it holds.
- **Under-scoped** — sibling files carry the same term with the same meaning. Lift it to the parent.
- **Shadowed** — a child restates an entry its parent already carries. Delete the child copy. Where the two meanings differ, the disagreement is the finding, not the duplication.
- **Missing** — a directory owns language true across its subtree and records it nowhere. Create the file.
- **Misfiled** — a documentation directory carries a context file. Move each entry to the code it describes and delete it.

A file that has grown large is over-scoped before it is verbose. Check what it holds against its subtree before cutting words.

## CONTEXT-MAP.md

The tree routes; the map does not. `CONTEXT-MAP.md` at the root records only what the hierarchy cannot express — how sibling contexts interact.

```md
# Context Map

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced`; Fulfillment consumes it to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched`; Billing generates the invoice
- **Ordering ↔ Billing**: shared `CustomerId` and `Money` types
```

Create it lazily, once a cross-cutting relationship is worth recording.
