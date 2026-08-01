# Setup Mode

Scaffold the per-repo configuration the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default; GitLab and local markdown supported)
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where `CONTEXT.md` and ADRs live, and the consumer rules for reading them

This is prompt-driven, not a script. Explore, present what you found, confirm, then write.

## 1. Explore

Read what exists; don't assume:

- `git remote -v` and `.git/config` — which forge, which repo?
- `AGENTS.md` at the repo root — does an `## Agent skills` section already exist?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/` — does prior output already exist?
- `.scratch/` — sign that a local-markdown convention is already in use

## 2. Present findings and ask

Summarise what's present and what's missing, then walk through the three decisions **one at a time** — present a section, get an answer, move on. Don't dump all three at once.

Assume the user does not know what these terms mean. Each section starts with a short explainer (what it is, why the skills need it, what changes if they pick differently), then the choices and the default.

**Section A — Issue tracker.**

> The "issue tracker" is where issues live for this repo. Triage, breakdown, and PRD modes read from and write to it — they need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe.

Default posture: propose whatever the `git remote` points at — GitHub, or GitLab (`gitlab.com` or self-hosted). Otherwise offer:

- **GitHub** — GitHub Issues via the `gh` CLI
- **GitLab** — GitLab Issues via the [`glab`](https://gitlab.com/gitlab-org/cli) CLI
- **Local markdown** — files under `.scratch/<feature>/` (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, …) — ask for a one-paragraph description; record it as freeform prose

**Section B — Triage label vocabulary.**

> When triage processes an incoming issue it moves through a state machine. To do that it applies labels (or the equivalent) that match strings *you've actually configured*. If the repo already uses different names (`bug:triage` instead of `needs-triage`), map them here so the skill applies the right ones instead of creating duplicates.

Default: each role's string equals its name. Ask whether any need overriding. If the tracker has no existing labels, the defaults are fine.

**Section C — Domain docs.**

> Some skills read `CONTEXT.md` for the project's domain language and `docs/adr/` for past architectural decisions. They need to know whether the repo has one context or several, so they look in the right place.

- **Single-context** — one `CONTEXT.md` + `docs/adr/` at the repo root. Most repos.
- **Multi-context** — `CONTEXT-MAP.md` at the root pointing to per-context `CONTEXT.md` files. Typically a monorepo.

## 3. Confirm and edit

Show a draft of the `## Agent skills` block and the three `docs/agents/*.md` files. Let the user edit before writing.

## 4. Write

Edit `AGENTS.md` at the repo root, creating it if absent. If an `## Agent skills` block already exists, update it in place rather than appending a duplicate. Don't overwrite surrounding sections.

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

Then write the three docs files from the seed templates:

- [tracker-github.md](./tracker-github.md), [tracker-gitlab.md](./tracker-gitlab.md), [tracker-local.md](./tracker-local.md) → `docs/agents/issue-tracker.md`
- [triage-labels.md](./triage-labels.md) → `docs/agents/triage-labels.md`
- [domain.md](./domain.md) → `docs/agents/domain.md`

For "other" trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

## 5. Done

Say which skills now read from these files, and that `docs/agents/*.md` can be edited directly later — re-running setup is only needed to switch trackers or start over.
