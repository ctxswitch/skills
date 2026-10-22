# TypeScript, React, and Tailwind

Each row is code you would type by reflex. The reflex is wrong; write the third column instead.

| Reflex | Why it is wrong | Instead |
|---|---|---|
| `as any`, `x!`, `@ts-expect-error` to make it compile | Hides a failing contract; `!` crashes in a real loading state | Narrow, or `unknown` parsed once at the boundary |
| `(await res.json()) as User` | Types do not validate | Parse at the entry, then trust inward |
| `if (value)` on a string, number, or array | Drops `""`, `0`, `[]` | An explicit check |
| `switch` with a `default:` that swallows variants | Silent on the next variant | An exhaustive `never` check |
| `useEffect(() => setDerived(compute(a)), [a])` | Derived state drifts | Compute during render |
| `// eslint-disable-next-line react-hooks/exhaustive-deps` | Stale closure | Restructure |
| `useMemo`, `useCallback` on everything | Noise | A measured cost or a referential contract a child depends on |
| A fetch in an effect whose input changes, with no abort or ignore flag | The slow earlier response overwrites the fresh one | Abort or ignore on cleanup |
| An effect that subscribes, starts a timer, or opens a connection with no return | Leak | Return the cleanup |
| `key={index}` on a list that reorders | State moves between rows | A stable id |
| `const Inner = () => ...` inside a component | Remounts every render | Hoist it |
| Loading, empty, error, retry, and unauthorized branches on every fetch | Resilience machinery | The states the surrounding components in this app render |
| `fetch(...)` not awaited; `.catch(() => {})` | Half-updated state; silent failure | Await it; surface the failure |
| `dangerouslySetInnerHTML={{ __html: s }}` | XSS | Sanitize at the boundary, or do not render HTML |
| `if (!user.isAdmin) return null` as authorization | Client-side hiding is not enforcement | The server enforces |
| `process.env.SECRET` in a client module | Leaks into the bundle | Server only |
| `` `text-${color}-600` `` | Tailwind cannot see the class | Complete class strings |
| A new CSS file, `@apply`, a `cn` helper, or `cva` in a repo without them | Churn | The repo's existing pattern |
| Extracting every repeated class list | Abstraction for a name | Extract only when the duplicate already drifts |
| `outline-none` with no replacement | Accessibility regression | `focus-visible:` ring |
| `strict: false` or a loosened `tsconfig` | Masks the bug | Fix the code |
| Vitest, Jest, Playwright, or Testing Library added where absent | Tool churn | The repo's runner |
| `--update-snapshot` to make a test pass | Hides a regression | Confirm the new output is intended first |
| `interface` to `type` or back | Churn | Match the file |
| Splitting a component "because it does several things" | Extraction for a name | Leave it |
