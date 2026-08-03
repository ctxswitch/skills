# Sweep Run Format

Two index files and one record per scope, under `.claude/context/<session>/`. Scope records mirror the repo tree, so a record's path is its scope's path plus `.md`.

```
.claude/context/<session>/
├── index.md
├── ledger.md
├── internal/
│   ├── order.md          ← internal/order
│   └── order/
│       └── parser.md     ← internal/order/parser
└── pkg/
    └── billing.md        ← pkg/billing
```

Use these templates exactly — a resumed run reads them without the session that wrote them.

## index.md

```md
# Sweep: {root scope}

## Scopes

Dependencies first. Extracted in pass one, reconciled in pass two.

| Scope | Extracted | Reconciled |
| ----- | --------- | ---------- |
| `internal/order` | x | x |
| `internal/billing` | x | |
| `internal/api` | | |

## Excluded

- `{path}` — {why it is not a scope}
```

Both lists grow during the walk, a row at a time, before any scope is read. A directory in neither list was never examined, which is where a resumed walk picks up. `## Excluded` is omitted where the walk ruled nothing out.

Nothing derivable goes here — no counts, no percentages, no summary of the ledger.

A row is never ticked ahead of the work it stands for. `Extracted` means the scope's record exists; `Reconciled` means its recorded context has been compared and the outcome written or ledgered.

## ledger.md

```md
# Ledger

## Open

### Order cancellation states

- **Raised**: `internal/order`
- **Code**: `Cancel()` sets `CANCELLED` from any state — `internal/order/service.go:142`
- **Claim**: cancellable only while `PENDING` — `.context.md`
- **Unresolved**: whether cancelling a shipped order is intentional
- **Evidence**:
  - `internal/billing/refund.go:88` — refunds a shipped order, so the path is reachable
  - `services/ordering/.context.md` — records no decision covering states after `SHIPPED`

## Resolved

### Customer vs User

- **Decision**: `Customer` is the paying entity, `User` is the login identity
- **Closed by**: `internal/auth/session.go:31` — `User` carries no billing reference
- **Written to**: `src/billing/.context.md`
```

An entry moves from `## Open` to `## Resolved` when the code closes it or the user decides. It is never deleted.

**Evidence** accumulates as the sweep proceeds. Each line carries a `file:line` and what it adds — not that it was read.

## {scope path}.md

```md
# internal/order

## Terms owned

**Order**: a customer's request for fulfilment, from placement to delivery — `types.go:18`
**Fulfilment**: the warehouse action that satisfies one Order — `fulfil.go:24`

## Limits

- an Order carries at most 200 line items — `validate.go:57`
- cancellation window is 30 minutes from placement — `service.go:96`

## Restrictions

- an Order cannot leave `DRAFT` without a payment method — `service.go:44`
- `Fulfil()` requires a confirmed payment; it panics otherwise — `fulfil.go:31`

## Checked

- over-scoped ×2 — `Fulfilment Window`, `Picker Batch` hold only for `internal/order/picking`
- redundant relationship — "cancellation closes after 30 minutes" restates the **Limits** entry
- clean: shape, naming, history, decisions

## Written

- **Order**, **Fulfilment** → `src/ordering/.context.md`
- moved `Fulfilment Window`, `Picker Batch` down to `internal/order/picking`
- dropped the restated cancellation relationship

## Raised

- Order cancellation states
```

Record what the code establishes, with a `file:line` for each. A claim with no citation does not go in.

`## Terms owned`, `## Limits`, and `## Restrictions` come from pass one and cite source only. `## Checked`, `## Written`, and `## Raised` are appended in pass two, once the scope's recorded context has been compared against them. A record carrying the first three and not the last three is an extracted scope awaiting reconciliation, which is exactly what its `index.md` row should say.

`## Checked` is where the validation survives. It names every check from [review.md](./review.md) that fired against this scope, and says `clean:` for the groups that passed. A scope whose record shows no `## Checked` was never validated, however finished the rest of it looks — and a group missing from both lists is one nobody ran.

`## Raised` lists ledger entry headings verbatim so an entry can be traced back to the scope that found it.

