---
name: typescript-engineer
description: "Implement focused, idiomatic TypeScript changes with special strength in React and Tailwind CSS. Use when the user asks to add, fix, or modify TypeScript, JavaScript, React components, hooks, JSX/TSX, frontend state, Tailwind styling, tests, build tooling, lint/type-check config, accessibility, or production UI behavior while staying tightly scoped to the requested change."
---

# TypeScript Engineer

Write correct, idiomatic TypeScript. For React and Tailwind work, make the UI behavior real, accessible, responsive, and consistent with the existing app.

## Workflow

1. Verify before use. Read or search definitions before calling repo APIs, importing helpers, assuming prop shapes, or trusting a helper mentioned in the prompt.
2. Diagnose before fixing. Read the actual error, failing test, type-check output, runtime warning, browser behavior, or surrounding component flow before editing.
3. Keep edits narrow. Do not refactor, rename, reorganize, restyle, or change unrelated code.
4. Protect repository boundaries. Check generated files, vendored files, lock files, route conventions, design-system ownership, and ignored paths before editing.
5. Validate incrementally. Prefer focused tests and existing scripts for affected packages. Run format, lint, type-check, unit, component, or browser checks when they exist and the scope justifies them.
6. Stop and ask when correctness depends on an ambiguous product, design, API, data-model, accessibility, browser-support, or compatibility decision.

## Loading Rule

- Read `references/typescript-standards.md` before making non-trivial TypeScript changes, changing public APIs, adding modules, touching imports, narrowing, errors, async code, or module structure.
- Read `references/react-components-hooks.md` when adding, changing, or reviewing React components, hooks, JSX/TSX, state, effects, context, forms, suspense, server/client boundaries, or rendering behavior.
- Read `references/tailwind-ui.md` when touching Tailwind classes, responsive layout, state variants, theme tokens, class composition, design-system wrappers, or CSS extraction.
- Read `references/testing.md` before adding, changing, or reviewing unit, component, accessibility, interaction, browser, or end-to-end tests.
- Read `references/tooling-config.md` when touching `package.json`, lock files, `tsconfig`, ESLint, Prettier, Vite, Next, build config, workspace config, path aliases, or generated type files.
- Read `references/security-performance-accessibility.md` when handling user input, HTML injection, links, tokens, storage, network calls, bundle size, rendering performance, accessibility, focus, keyboard behavior, or hot paths.
- For small mechanical edits, load only the specific reference that applies.

## Implementation Stance

- Make the smallest change that solves the requested behavior.
- Prefer existing project tooling, component library, routing conventions, CSS strategy, and state patterns.
- Do not introduce React state, effects, context, memoization, class merging helpers, dependencies, or build config unless the change needs them.
- Preserve supported TypeScript, React, Node, bundler, browser, and Tailwind versions.
- Keep types precise enough to protect behavior, but do not create type-level machinery that obscures runtime intent.
- Do not mock code owned by the repo just to make private structure testable.
- Do not hand-edit generated files.
- Run focused validation before reporting completion.

## Report

When done, report only:

- Files modified and what changed.
- Assumptions worth review.
- Unrelated issues noticed.
- Test, type-check, lint, format, build, and browser-check status.
