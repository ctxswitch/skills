# Tooling and Config

Use this reference for package metadata, dependency changes, `tsconfig`, ESLint, Prettier, Vite, Next, Tailwind config, workspaces, generated types, and build behavior.

## Core Stance

- Match the repository's package manager, workspace layout, script names, build tool, formatter, linter, and TypeScript version.
- Treat lock files as part of dependency changes. Do not edit lock files by hand.
- Avoid tool churn. Do not introduce or replace ESLint, Prettier, Biome, Vite, Next, Tailwind, Jest, Vitest, Playwright, or package managers without explicit scope.
- Preserve CI behavior. Local scripts should align with what CI runs.
- Config changes have broad blast radius. Keep them narrow and validate with the affected script.

## Package and Dependency Changes

- Check the current package manager from lock files and package metadata.
- Add runtime dependencies only when production code imports them.
- Add dev dependencies only for tests, tooling, types, build, or local development.
- Prefer existing dependencies and local utilities before adding new packages.
- Verify Node engine, ESM/CJS compatibility, bundler compatibility, tree-shaking, and browser support.
- Avoid adding dependencies for small helpers that are easy and clear locally.
- For monorepos, add dependencies to the package that actually uses them.

## TypeScript Config

- Understand whether the repo uses one `tsconfig`, project references, app/package-specific configs, or generated configs.
- Preserve `strict` and related safety flags unless the task is a deliberate migration.
- Be careful changing `module`, `moduleResolution`, `target`, `lib`, `jsx`, `paths`, `baseUrl`, `types`, `noEmit`, `isolatedModules`, and `verbatimModuleSyntax`.
- Align JSX settings with the framework and React version.
- Path aliases require matching support in the bundler, test runner, runtime, and IDE.
- Include/exclude patterns should not accidentally type-check build output, generated clients, or unrelated workspace packages.

## ESLint, Formatting, and Typed Linting

- Follow existing ESLint flat config or legacy config style.
- Type-aware linting is more powerful but slower; only enable or expand it deliberately.
- Do not disable rules globally for a local problem. Prefer local fixes, scoped overrides, or a documented exception.
- Preserve React hooks linting. Do not suppress dependency warnings without restructuring or a clear invariant.
- Formatting should be handled by the repo's formatter. Do not mix manual formatting style changes with behavior changes.

## Build Tools and Frameworks

- Vite, Next, Remix, Astro, and other frameworks have different server/client, environment variable, routing, and asset rules. Follow the app's convention.
- Do not expose server-only environment variables to client bundles.
- Preserve code-splitting and lazy-loading boundaries.
- Be careful with plugin ordering; it can affect TypeScript paths, React transforms, Tailwind, SVGs, MDX, and environment replacement.
- Generated type files should come from the generator command, not manual edits.

## Tailwind Config

- Tailwind content/source detection must include all files that contain complete class names.
- Theme changes should use existing tokens and naming patterns.
- Adding custom variants, plugins, or theme variables affects every component; validate representative UI.
- Avoid safelisting broad patterns unless dynamic class generation is truly unavoidable.
- Keep dark mode and state variant strategy consistent with the app.

## Common Findings

- Dependency added to the wrong workspace package.
- Lock file missing or hand-edited after package metadata changed.
- `tsconfig` loosened to avoid fixing type errors.
- Path alias works in TypeScript but fails in tests or runtime.
- ESLint rule disabled globally for a narrow false positive.
- Hooks lint warning suppressed, causing stale closure risk.
- Tailwind source detection misses a new directory or package.
- Build config exposes a secret or bundles server-only code into the client.
