# Tailwind UI

Use this reference for Tailwind CSS classes, responsive layouts, variants, design tokens, class composition, and extraction.

## Core Stance

- Prefer the repo's existing design system and component primitives over one-off styling.
- Tailwind classes should describe layout and state clearly. Long class lists are acceptable when they are static, readable, and local.
- Use design tokens and theme variables already present in the project. Avoid arbitrary colors, spacing, shadows, and breakpoints unless the design requires a true one-off.
- Build mobile-first. Unprefixed utilities define the base/mobile layout; breakpoint variants layer on larger-screen behavior.
- Use semantic HTML and accessibility attributes before styling the element to look interactive.
- Do not introduce CSS files, `@apply`, class-merging helpers, component variants, or dependencies unless the codebase already uses them or duplication/complexity justifies it.

## Class Detection and Composition

- Keep class names statically discoverable. Tailwind extraction cannot reliably detect classes assembled from arbitrary string fragments.
- Prefer complete conditional class strings over interpolated fragments like `` `text-${color}-600` ``.
- Use existing helpers such as `cn`, `clsx`, `cva`, `tailwind-merge`, or local variant utilities when the repo already has them.
- If mutually exclusive utilities can conflict, use the repo's class merge helper or structure conditionals so only one wins.
- Keep component variants explicit: size, tone, intent, disabled, selected, active, invalid, and loading should map to clear classes.
- Avoid extracting every repeated class list. Extract when duplication creates drift, hides intent, or represents a reusable component.

## Responsive Layout

- Start with the smallest viewport and add `sm:`, `md:`, `lg:`, `xl:`, or `2xl:` only where the design changes.
- Remember that `sm:` means "at least the small breakpoint", not "mobile".
- Use container queries when a component should respond to its container rather than the whole viewport and the project supports them.
- Use stable dimensions for fixed-format UI: grids, boards, icon buttons, avatars, media slots, tables, and controls should not jump when content changes.
- Constrain overflow intentionally. Long labels, URLs, code, and user content need wrapping, truncation, or scroll behavior.
- Check interactive states across breakpoints; hover-only behavior must have keyboard/touch alternatives.

## State Variants

- Use variants for real states: `hover:`, `focus-visible:`, `active:`, `disabled:`, `aria-*`, `data-*`, `group-*`, `peer-*`, responsive variants, dark mode, and motion preference.
- Prefer `focus-visible` for keyboard focus styling. Do not remove outlines without a replacement.
- Style disabled, pending, selected, invalid, expanded, current, and pressed states visibly.
- Use `aria-*` and `data-*` variants when component state is already represented in attributes.
- Avoid hover-only affordances for critical actions.

## Visual Quality

- Match existing spacing, radius, border, elevation, typography, and color use.
- Keep cards, panels, buttons, and inputs consistent with the app's design language.
- Avoid decorative gradients, one-note palettes, and excessive shadows unless they match the product.
- Prefer real content states over placeholder-heavy UI. Include loading, empty, error, disabled, and overflow states when the component needs them.
- Ensure text fits at mobile and desktop sizes. Do not scale font size with viewport width unless the project already has a safe fluid type system.
- Use icons from the existing icon library when available.

## Common Findings

- Dynamic class construction prevents Tailwind from generating required CSS.
- Breakpoint classes are inverted, causing desktop styles on mobile or mobile styles on desktop.
- Multiple mutually exclusive utilities depend on accidental class ordering.
- A component introduces arbitrary values where existing tokens would fit.
- Focus, disabled, selected, error, or loading states are unstyled.
- Long text or user content overflows controls, cards, nav, or tables.
- Styling duplicates an existing design-system component instead of reusing it.
- Responsive layout works at one viewport but overlaps or collapses at another.
