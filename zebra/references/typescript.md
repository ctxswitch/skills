# TypeScript and React

Things that fail in TypeScript with no code added. Nothing else in the language is evidenced by construction.

- Types do not validate. Data from the network, storage, URL params, forms, cookies, and `postMessage` is `unknown` at the single point it is parsed. Parse it there into the typed shape, then trust it inward.
- `any`, `as`, and `!` hide a failing contract. `!` on a nullable crashes when the value is absent in a real route or loading state. Prove the invariant nearby or narrow.
- A promise not awaited on a line that affects correctness, cleanup, navigation, or persisted state leaves state half-updated when it rejects.
- `catch` that ignores the error is silent failure. If the operation is best-effort, make the failure observable.
- An effect that fetches on an input that changes races: the slow earlier response overwrites the fresh one. That effect needs a stale-response guard or an abort. A fetch on mount with no changing input does not.
- An effect that subscribes, starts a timer, opens a connection, or starts cancellable work leaks without cleanup.
- An effect with a suppressed dependency reads stale values. Restructure instead of suppressing.
- A list keyed by index moves state between rows when the list reorders.
- Mutating props, state, or query results renders inconsistently.
- Do not define components inside components.
