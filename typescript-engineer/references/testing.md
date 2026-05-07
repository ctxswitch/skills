# Testing TypeScript, React, and UI

Use this reference for unit tests, component tests, accessibility checks, browser checks, and end-to-end tests.

## Core Stance

- Follow the repo's existing test runner and conventions. Do not introduce Vitest, Jest, Testing Library, Playwright, Cypress, Storybook, or browser-mode testing unless the project already uses it or the user asks.
- Test behavior and user-visible outcomes before implementation details.
- Prefer small, focused tests near the changed code for logic and components. Use browser/end-to-end tests for routing, integration, layout-sensitive, or cross-component flows.
- Tests should fail for the bug or behavior being changed, not for incidental implementation details.
- Keep mocks at process boundaries: network, clock, storage, routing, browser APIs, and third-party services. Avoid mocking repo-owned modules when a real integration is cheap and stable.

## Unit Tests

- Test pure TypeScript functions with direct inputs and outputs.
- Cover edge cases around nullable values, discriminated unions, parsing, date/time, ordering, permissions, and error paths.
- Use table tests when the same behavior has multiple meaningful cases.
- Avoid snapshot tests for logic.
- Keep fake timers explicit and restore them after use.

## React Component Tests

- Query the DOM like a user: role, label text, visible text, placeholder, display value, and accessible name.
- Prefer `userEvent`-style interactions over firing low-level events when the test is about user behavior.
- Assert visible states: loading, error, empty, disabled, selected, expanded, invalid, and success.
- Assert focus movement and keyboard behavior for menus, dialogs, forms, comboboxes, tabs, and custom controls.
- Do not test component internals, hook call order, private state names, or CSS class details unless the class is the behavior under test.
- For async UI, wait for the user-visible result instead of implementation-specific promises.

## Network and Async

- Mock network at the request boundary with the project's existing tool.
- Cover success, loading, empty, error, retry, cancellation, and stale-response behavior when relevant.
- Verify mutations update or invalidate visible state.
- Avoid tests that depend on real time, real network, local machine locale, or test ordering.

## Browser and End-to-End Checks

- Use browser tests for workflows that need real navigation, forms, dialogs, focus, media queries, browser APIs, hydration, or layout.
- Prefer resilient locators based on role, label, and accessible name.
- Avoid arbitrary sleeps. Wait for explicit UI states, network completion, or locator assertions.
- Check mobile and desktop viewports when the change affects responsive layout.
- For Tailwind-heavy UI, a screenshot or Playwright check is useful when overlap, truncation, or visual state is a risk.

## Type, Lint, and Build Validation

- Run the repo's type-check for changes that affect public types, props, API clients, package exports, or generated types.
- Run lint when changing hooks, dependencies, imports, accessibility-sensitive JSX, or config.
- Run build when changing bundler config, server/client boundaries, route files, exports, package metadata, or Tailwind config.
- Do not hide test failures by updating snapshots or weakening assertions without confirming the new behavior is intended.

## Common Findings

- Test asserts class names or private state while missing the user-visible behavior.
- Missing regression test for a fixed bug.
- Async test can pass before the UI actually updates.
- Network mock does not match the real request shape.
- Component test lacks keyboard/focus coverage for a custom interactive control.
- Responsive or Tailwind change has no browser/screenshot coverage despite layout risk.
- Snapshot update masks a behavior regression.
- Type-check, lint, or build script was not run after touching config or public types.
