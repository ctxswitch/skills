# Security, Performance, and Accessibility

Use this reference for untrusted input, HTML injection, links, tokens, storage, network calls, rendering cost, bundle size, accessibility, focus, and keyboard behavior.

## Security

- Treat user input, URL params, route params, form data, local/session storage, cookies, postMessage, server-rendered JSON, and API responses as untrusted.
- Avoid `dangerouslySetInnerHTML`. If HTML rendering is required, sanitize with an established sanitizer at the boundary and document the trust source.
- Do not put secrets, private tokens, service keys, or server-only environment variables in client bundles.
- Use safe link behavior. External links opened in a new tab should avoid opener access where the framework does not handle it.
- Validate redirect targets and return URLs. Avoid open redirects.
- Avoid string-built SQL, shell commands, URLs, HTML, CSS, or selectors from untrusted data.
- Keep auth and authorization checks on the server. Client-side hiding is not enforcement.
- Be careful persisting sensitive data in local storage; prefer secure, HTTP-only cookies or server-side state when appropriate.

## Network and Data

- Handle loading, success, empty, error, retry, unauthorized, and stale states where they are possible.
- Use abort/cancellation or stale guards for requests tied to rapidly changing inputs or component lifetime.
- Avoid duplicate requests caused by effects, unstable dependencies, or Strict Mode behavior.
- Do not leak implementation errors directly to users. Keep detailed errors in logs/telemetry where the repo supports it.

## Performance

- Optimize for measured or plausible user-visible cost, not theoretical micro-optimizations.
- Keep render pure and cheap. Move expensive calculations behind memoization only when inputs are clear and the cost matters.
- Avoid unnecessary state that causes extra renders. Derive values during render when cheap.
- Avoid creating large objects, arrays, or closures in hot list items when they feed memoized children or virtualization boundaries.
- Use stable keys and virtualization/pagination for large lists.
- Preserve lazy loading and code-splitting boundaries. Do not import heavy editor, chart, map, date, markdown, or syntax-highlight libraries into common bundles casually.
- For images and media, preserve sizing, lazy-loading, alt text, and responsive sources used by the app.

## Accessibility

- Prefer semantic elements: buttons for actions, anchors for navigation, labels for inputs, headings for structure, lists for lists.
- Every interactive control needs an accessible name, keyboard access, visible focus, disabled state, and appropriate role/state.
- Do not build custom controls when native controls fit.
- Use `aria-*` to expose real state, not to paper over non-semantic markup.
- Manage focus for dialogs, popovers, menus, route transitions, validation errors, and destructive confirmations.
- Ensure error messages are associated with fields and announced when appropriate.
- Preserve color contrast and do not rely on color alone for status.
- Respect reduced motion where animations are significant.

## Tailwind-Specific Risks

- Removing focus rings or outlines without replacement is an accessibility regression.
- `hidden`, `sr-only`, `invisible`, `opacity-0`, and `pointer-events-none` have different accessibility and interaction effects; choose intentionally.
- Responsive classes can hide required controls at some breakpoints.
- Dark mode variants need sufficient contrast independently from light mode.
- Motion and transition utilities should not make essential state changes hard to perceive.

## Common Findings

- Unsanitized HTML reaches `dangerouslySetInnerHTML`.
- Server-only environment value is referenced in client code.
- Client checks are treated as authorization.
- Async requests race and stale data overwrites fresh state.
- Required action is hover-only or mouse-only.
- Focus is lost or trapped incorrectly in a modal/menu/popover.
- Input has no label or error association.
- New Tailwind class removes visible focus.
- Large dependency or import lands in a shared client bundle without need.
