# Run File Format

Three files under `.claude/drift/<session>/`. Use these templates exactly — a resumed run reads them without the session that wrote them.

## index.md

```md
# Drift run: {scope}

## Modules

Dependencies first. Check each off when its file is written.

- [x] `internal/order`
- [x] `internal/billing`
- [ ] `internal/api`
```

Nothing derivable goes here — no counts, no percentages, no summary of the ledger.

## ledger.md

```md
# Ledger

## Open

### Order cancellation states

- **Raised**: `internal/order`
- **Code**: `Cancel()` sets `CANCELLED` from any state — `internal/order/service.go:142`
- **Claim**: cancellable only while `PENDING` — `CONTEXT.md`
- **Unresolved**: whether cancelling a shipped order is intentional
- **Evidence**:
  - `internal/billing/refund.go:88` — refunds a shipped order, so the path is reachable
  - `docs/adr/0004-order-lifecycle.md` — silent on states after `SHIPPED`

## Resolved

### Customer vs User

- **Decision**: `Customer` is the paying entity, `User` is the login identity
- **Closed by**: `internal/auth/session.go:31` — `User` carries no billing reference
- **Written to**: `src/billing/CONTEXT.md`
```

An entry moves from `## Open` to `## Resolved` when the code closes it or the user decides. It is never deleted.

**Evidence** accumulates as the sweep proceeds. Each line carries a `file:line` and what it adds — not that it was read.

## {module}.md

One per swept module, named for its path with separators flattened: `internal-order.md`.

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

## Written

- **Order**, **Fulfilment** → `src/ordering/CONTEXT.md`

## Raised

- Order cancellation states
```

Record what the code establishes, with a `file:line` for each. A claim with no citation does not go in.

`## Raised` lists ledger entry headings verbatim so an entry can be traced back to the module that found it.
