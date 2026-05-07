# React Components and Hooks

Use this reference for React components, hooks, JSX/TSX, state, effects, context, server/client boundaries, and rendering behavior.

## Core Stance

- Components and hooks must be pure during render: same inputs should produce the same output, and side effects should run in event handlers or effects.
- Props and state are immutable snapshots. Never mutate them directly.
- Prefer deriving render data from props/state during render over storing duplicated derived state.
- Use effects to synchronize with external systems, not to compute values that can be derived during render.
- Match the app's framework conventions for server components, client components, routing, data loading, mutations, cache invalidation, and forms.
- Make UI behavior accessible by default: semantic elements first, keyboard interaction, focus management, labels, and states.

## Component Shape

- Keep components focused on one responsibility. Split when a component mixes unrelated data fetching, layout, form state, and low-level UI mechanics.
- Keep prop shapes coherent. Prefer a discriminated union over many optional props when variants have different required fields.
- Use children and composition for layout slots when that matches existing design-system style.
- Avoid defining components inside components unless intentionally resetting state every render.
- Use stable keys for lists and for intentionally resetting state. Do not use keys to force rerenders as a substitute for correct state flow.
- Preserve controlled/uncontrolled conventions for inputs. Do not switch a field between controlled and uncontrolled after mount.

## State

- Keep state minimal and colocated with the owner of the behavior.
- Lift state only when multiple components need the same source of truth or when state must survive child unmounting.
- Use reducers for state transitions that have multiple events, branches, or invariants.
- Use refs for mutable values that do not affect rendering, such as DOM nodes, timer IDs, and latest callback references.
- Do not store props in state unless you intentionally want a reset boundary or local draft.
- When identity changes should reset child state, use an explicit `key` tied to that identity.

## Effects

- First ask whether the effect is needed. Derived values, filtered lists, class names, and event-specific work usually do not belong in an effect.
- Include all reactive values in effect dependencies. If that causes unwanted reruns, change the code structure instead of suppressing the dependency.
- Effects that subscribe, start timers, open connections, add listeners, or kick off cancellable work must clean up.
- Protect async effects from stale responses with cancellation, abort signals, or a local ignore flag.
- Do not use effects to mirror state into state. Prefer deriving during render or updating both values in the original event.
- Keep effects narrow: one synchronization concern per effect.

## Hooks

- Call hooks only at the top level of React functions or custom hooks.
- Custom hooks should be named `use*`, hide reusable stateful behavior, and expose a small API.
- A custom hook is worthwhile when it removes real duplication or clarifies a reusable external-system synchronization.
- Do not return unstable objects/functions from hooks when callers reasonably depend on referential stability, unless local convention accepts it.
- Avoid memoization by reflex. Use `useMemo` and `useCallback` for expensive calculations, referential contracts, or preventing real rerenders, not as decoration.

## Forms and Events

- Prefer semantic form controls with labels, validation messages, and disabled/loading states.
- Keep form submission atomic. Avoid double-submit races by disabling or guarding while pending.
- Avoid reading stale state inside async handlers. Capture values explicitly or use functional updates.
- Use the framework's form/action/data-mutation conventions when the repo has them.
- For client validation, keep messages specific and consistent with server validation.

## Server and Client Boundaries

- Do not pull client-only hooks, browser APIs, or interactive components into server-only modules.
- Keep server-only secrets and privileged calls out of client bundles.
- Pass serializable data across server/client boundaries unless the framework supports a richer contract.
- Be careful with hydration-sensitive values: dates, random values, viewport-dependent branches, and local storage should not change server/client initial render unexpectedly.

## Common Findings

- State is duplicated from props and can drift.
- Effect computes something that should be derived during render.
- Missing cleanup leaks timers, event listeners, subscriptions, or in-flight requests.
- Effect dependencies are suppressed and can read stale values.
- Component mutates props/state, causing inconsistent rendering.
- List keys are unstable, causing state to move between rows.
- Nested component definitions reset child state unexpectedly.
- Browser-only code runs during server render.
- Required interactive UI lacks keyboard, focus, label, or screen-reader behavior.
