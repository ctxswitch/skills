# .context.md Format

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

## Defects

- **dead-code** `dispatch.go:212` — `retryAll` defined, never called
- **stale-reference** `fulfil.go:24` — cites `NewPicker`; the constructor is `SetupPicker`
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others as aliases to avoid.
- **An alias line can carry its distinction.** Where the avoided word names a genuinely different thing rather than a synonym, say which is which. That is what stops the two collapsing back together.
- **Name a term for its referent, not its neighbours.** A term whose definition reaches wider than its name is misnamed, however well the name fits its siblings. Test each entry by reading its name against the reach of its own definition.
- **Omit a heading with nothing behind it.** A section is deleted, not filled. Levels that carry no ambiguities or no dialogue simply have neither.
- **Flag conflicts explicitly.** If a term is used ambiguously, call it out in "Flagged ambiguities" with its resolution. An entry with no resolution yet belongs there too, saying what disagrees and what would settle it — an unresolved conflict recorded only in a run's ledger is lost the moment that run ends.
- **Keep definitions tight.** One sentence max. Define what it IS, not what it does.
- **Record what is, not how it got here.** Migration numbers, issue numbers, dates, and "previously X, now Y" framing are history that `git log` already holds. A legacy path still running is current behaviour and belongs; how it arrived does not.
- **Every entry reads on its own.** A line needing an issue, a migration, a prior run, or a conversation to make sense belongs somewhere else. State the constraint so it stands without the reference.
- **A reason names a mechanism, not a merit.** It names the thing forcing the constraint — a foreign key, a build step, a token binding — so a reader can check it. "Since `agents.tenant_id` is `ON DELETE RESTRICT`" earns its clause; "which is the one ambiguity this scope most has to hold apart" does not.
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

## Defects

Code faults this scope carries that no recorded language depends on: dead functions, comments citing something gone, a name disagreeing with what it names. Recorded so the next sweep recognises rather than rediscovers them.

A line is a kind, a `file:line`, and what is wrong. Nothing else — no proposed fix, no severity, no reasoning.

```md
- **dead-code** `queues.go:96,189` — `ServiceableTags` both forms, no production caller since #96
- **stale-reference** `tenant_source.go:23` — cites "agent ADR-0002"; no ADR files exist
```

A fault that changes what a recorded term means is not a defect entry. It is current behaviour and belongs in `## Relationships` — that nothing registers a metric family says what the family *is*, and a reader of the term needs it.

Entries are verified against source on each sweep and dropped once the fault is gone.

## Scope

Context files form a hierarchy, each describing only what is true at its own level.

**A fact belongs at the shallowest directory where it holds for everything beneath it, and no shallower.**

```
.context.md                          the product — what it is, who uses it
services/.context.md                 the services and what each is for
services/billing/.context.md         the billing domain
services/billing/ledger/.context.md  the ledger's own terms
```

A reader loads the root file down to the directory being worked in, and every level assumes its ancestors. Nothing is repeated from a parent.

Every directory holding authored source of its own carries a `.context.md`, including packages whose language is narrow or mechanical. Whether an entry is "obvious" is not the test — obviousness varies by reader, and a file one run creates and the next deletes churns the hierarchy.

A directory holding only subdirectories carries a file only where it records something true of every scope beneath it. With nothing spanning, it carries none.

Generated output carries none. Its language belongs to the scope owning the generator input — the protobuf definitions, not the emitted client.

An entry whose directory does not exist yet lives at the nearest existing ancestor and moves down once the directory arrives. `_Pending_:` names the intended home.

A directory holding documents rather than code owns no scope. `docs/` and its subtrees never carry a `.context.md` — a document is context already, and the language it uses belongs with the code it describes.

### Misplacement

- **Over-scoped** — the file states something untrue of part of its subtree. Move it down to where it holds.
- **Under-scoped** — sibling files carry the same term with the same meaning. Lift it to the parent.
- **Shadowed** — a child restates an entry its parent already carries. Delete the child copy. Where the two meanings differ, the disagreement is the finding, not the duplication.
- **Missing** — a directory owns language true across its subtree and records it nowhere. Create the file.
- **Misfiled** — a documentation directory carries a context file. Move each entry to the code it describes and delete it.

A file that has grown large is over-scoped before it is verbose. Check what it holds against its subtree before cutting words.

A relationship that crosses scopes is recorded in the scope that would have to change if it changed — Ordering emitting `OrderPlaced` is Ordering's entry, not Fulfillment's and not a shared file's. A root-level map of how the scopes interact is a second copy of facts each scope already owns: nothing forces a code change to update it, so it drifts.
