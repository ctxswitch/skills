# TypeScript Standards

Use this reference for TypeScript source, module structure, public APIs, narrowing, async code, and type-system decisions.

## Core Stance

- Treat TypeScript as a static model over JavaScript runtime behavior. Types should document and protect real runtime contracts, not replace runtime validation at trust boundaries.
- Prefer code that is easy to read at runtime over clever type-level machinery.
- Keep inference where it improves clarity. Add explicit types at public boundaries, exported functions, reusable component props, callbacks with non-obvious contracts, and places where inference widens or hides intent.
- Preserve the repo's configured strictness. Do not loosen `tsconfig` to make a change pass unless the user explicitly asks for a configuration migration.
- Use `unknown` for untrusted values and narrow them before use. Avoid `any`; if it is unavoidable, keep it local, explain why, and do not let it escape public APIs.
- Prefer discriminated unions for state machines, variants, async states, and result shapes.
- Prefer `interface` or `type` according to local convention. Do not churn one to the other without a reason.

## Public APIs

- Public functions should have clear parameter and return types.
- Public component props should be named and exported when they are reused by callers or tests.
- Use `readonly` and immutable collection types for inputs that must not be mutated.
- Prefer literal unions or discriminated unions over boolean flag combinations when states are mutually exclusive.
- Use `satisfies` when checking an object against a shape while preserving literal inference.
- Avoid overly broad `Record<string, unknown>` when a known key set exists.
- Avoid exposing implementation-specific generics. A generic type parameter should be needed by the caller and appear in the input/output relationship.
- Avoid ambient declarations unless they are the actual integration point for generated globals, framework globals, or missing third-party types.

## Narrowing and Runtime Data

- Narrow nullable and optional values before use. Prefer early returns when they reduce nested code.
- Validate data from network responses, local storage, URL params, postMessage, forms, cookies, and server-provided JSON before trusting it.
- Keep parsing at the boundary. Convert unknown/raw shapes into domain shapes once, then pass the parsed shape inward.
- Do not silence nullable errors with `!` unless the invariant is already proven nearby or enforced by the framework.
- Prefer exhaustive checks for discriminated unions. A default branch that swallows future variants can hide bugs.
- Avoid truthiness checks when empty strings, zero, or empty arrays are valid values.

## Modules and Imports

- Match the repo's module system and import style. Do not mix CommonJS and ESM casually.
- Keep type-only imports type-only when the project distinguishes them.
- Respect path aliases and package boundaries. Do not deep-import private files from sibling packages unless that is an established contract.
- Avoid circular imports, especially between component modules and hooks/state modules.
- Keep module top-level code side-effect free unless the module's purpose is registration or initialization.
- Preserve tree-shaking: avoid barrel exports that pull heavy client-only modules into server or shared bundles.

## Errors and Async

- Await promises that affect correctness, cleanup, navigation, user feedback, or persisted state.
- Handle expected failures close to the operation and expose user-appropriate errors at UI boundaries.
- Do not catch and ignore errors unless the behavior is intentionally best-effort and observable enough for debugging.
- Use `AbortController`, framework cancellation, or stale-response guards for async work tied to component lifetime or changing inputs.
- Avoid async functions in places that ignore returned promises unless the framework explicitly supports them.
- Prefer `Promise.all` for independent async work and sequential awaits when order or backpressure matters.

## Objects, Arrays, and Mutation

- Avoid mutating props, state, cache snapshots, query results, or inputs owned by callers.
- Local mutation is fine when it is confined to one calculation and cannot leak.
- Use stable identifiers for collections. Do not use array indexes as IDs when items can reorder, insert, or delete.
- Prefer `Map`/`Set` when key lookup or uniqueness is central to the behavior.
- Be careful with object spreading when nested data needs structural updates; shallow copies do not protect nested values.

## Common Findings

- `any` or assertion hides a failing contract at an API or data boundary.
- Non-null assertion can crash when the value is absent in a real route, loading state, or test setup.
- A union is not exhaustively handled, so a new variant renders wrong UI or silently does nothing.
- A type says a field is required, but runtime data allows it to be missing.
- A broad callback or generic allows callers to pass values the implementation cannot handle.
- A deep import bypasses package ownership or breaks build output.
- Promise rejection is ignored and can leave UI stale or state partially updated.
- `tsconfig` strictness, module resolution, JSX, or emit settings are changed to mask an implementation bug.
