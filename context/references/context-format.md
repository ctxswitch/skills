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
_Fixed_: an issued Invoice is immutable — corrections are credit notes, not edits

**Customer**: A person or organization that places orders.
_Avoid_: Client, buyer, account

**Fulfillment**: The warehouse action that satisfies one Order.
_Avoid_: Shipment, dispatch
_Pending_: not built — expected at `services/fulfillment`

## Relationships

- An **Order** produces one or more **Invoices**
- An **Invoice** belongs to exactly one **Customer**

## Decisions

- Ordering reaches Fulfillment by domain events, not synchronous HTTP — a synchronous call would couple order acceptance to warehouse availability

## Example dialogue

> **Dev:** "When a **Customer** places an **Order**, do we create the **Invoice** immediately?"
> **Domain expert:** "No — an **Invoice** is only generated once a **Fulfillment** is confirmed."

## Flagged ambiguities

- "account" was used to mean both **Customer** and **User** — resolved: these are distinct concepts.
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others as aliases to avoid.
- **An alias line can carry its distinction.** Where the avoided word names a genuinely different thing rather than a synonym, say which is which. That is what stops the two collapsing back together.
- **Name a term for its referent, not its neighbours.** A prefix shared across sibling terms is a pattern, not a convention to satisfy — a term whose definition reaches wider than its name is misnamed however well the name fits the family. Where one word carries two senses, separate them by naming each for what it is, rather than qualifying both with the same modifier. Test every entry by reading its name against the reach of its own definition.
- **Omit a heading with nothing behind it.** A section is deleted, not filled. Levels that carry no ambiguities or no dialogue simply have neither.
- **Flag conflicts explicitly.** If a term is used ambiguously, call it out in "Flagged ambiguities" with a clear resolution.
- **Keep definitions tight.** One sentence max. Define what it IS, not what it does.
- **Record what is, not how it got here.** An entry describes current behaviour. Migration numbers, issue numbers, dates, release names, and "previously X, now Y" framing are history — `git log`, the migrations, and the tracker already hold them, and repeating them here is a second changelog to maintain. Where a legacy path still runs, that is current behaviour and belongs; that it arrived in some particular change does not.
- **Every entry reads on its own.** A line needing an issue, a migration, a prior run, or a conversation to make sense belongs somewhere else. State the constraint so it stands without the reference.
- **A reason names a mechanism, not a merit.** Where an entry gives a reason, it names the thing in this scope that forces the constraint — a foreign key, a build step, a token binding — so a reader can check it against the code. It does not argue the decision was correct, rank its importance, or replay the reasoning that produced it. "Handle `agents` rows before `tenants` rows, since `agents.tenant_id` is `ON DELETE RESTRICT`" earns its clause; "which is the one ambiguity this scope most has to hold apart" does not.
- **A reason never imports another scope's facts.** Where a constraint depends on something a different scope owns, name the term and stop. Restating the fact here makes a second copy that nothing keeps current, and it ages independently of the scope that owns it.
- **Show relationships.** Use bold term names and express cardinality where obvious.
- **Record what callers rely on, not the pattern it is built from.** A scope's own contracts belong however mundane — the cap it enforces, the state it refuses, the default it applies. The general pattern behind them does not: a retry helper records its backoff ceiling and what it treats as retryable, not what a retry is.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.
- **Write an example dialogue.** A conversation between a dev and a domain expert that demonstrates how the terms interact naturally and clarifies boundaries between related concepts.
- **Record a decision where it constrains.** A decision about one term goes on that term as `_Fixed_:`. `## Decisions` takes only what constrains the scope rather than a term.
- **Mark language that has no code yet.** `_Pending_:` names that the term is unbuilt and where the code is expected. Until it arrives the entry is intent, not a description of anything.

## Decisions

A decision earns a line only while someone would still reach for the alternative. Name who would propose it and what would make it look right — if you cannot, drop it. The outcome recorded elsewhere is usually enough on its own: `## Relationships` stating that Ordering emits `OrderPlaced` already closes "why not HTTP" unless HTTP is a live temptation.

A line carries the constraint and the rejected alternative, nothing else — not the discussion, not who decided, not the change that enacted it.

Entries expire. When the alternative stops being plausible, drop the line — `git log` on the file keeps what was removed, and the diff is the record of when it changed and from what.

## Scope

Context files form a hierarchy, each describing only what is true at its own level.

**A fact belongs at the shallowest directory where it holds for everything beneath it, and no shallower.**

```
CONTEXT.md                          the product — what it is, who uses it
services/CONTEXT.md                 the services and what each is for
services/billing/CONTEXT.md         the billing domain
services/billing/ledger/CONTEXT.md  the ledger's own terms
```

A reader loads the root file down to the directory being worked in, and every level assumes its ancestors. Nothing is repeated from a parent.

Every directory holding authored source of its own carries a `CONTEXT.md`, including packages whose language is narrow or mechanical — a utility package records what its callers may rely on. Whether an entry is "obvious" is not the test. Obviousness varies by reader, so a file one run creates and the next deletes churns the hierarchy for no gain.

A directory holding only subdirectories carries a file only where it records something true of every scope beneath it. With nothing spanning, it carries none.

Generated output carries none. Its language belongs to the scope owning the generator input — the protobuf definitions, not the emitted client.

An entry whose directory does not exist yet lives at the nearest existing ancestor and moves down once the directory arrives. `_Pending_:` names the intended home.

A directory holding documents rather than code owns no scope. `docs/` and its subtrees never carry a `CONTEXT.md` — a document is context already, and the language it uses belongs with the code it describes.

### Misplacement

- **Over-scoped** — the file states something untrue of part of its subtree. Move it down to where it holds.
- **Under-scoped** — sibling files carry the same term with the same meaning. Lift it to the parent.
- **Shadowed** — a child restates an entry its parent already carries. Delete the child copy. Where the two meanings differ, the disagreement is the finding, not the duplication.
- **Missing** — a directory owns language true across its subtree and records it nowhere. Create the file.
- **Misfiled** — a documentation directory carries a context file. Move each entry to the code it describes and delete it.

A file that has grown large is over-scoped before it is verbose. Check what it holds against its subtree before cutting words.

A relationship that crosses scopes is recorded in the scope that would have to change if it changed — Ordering emitting `OrderPlaced` is Ordering's entry, not Fulfillment's and not a shared file's. A root-level map of how the scopes interact is a second copy of facts each scope already owns: nothing forces a code change to update it, so it drifts.
