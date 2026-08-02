# Skills

My personal skills for Codex, Claude Code, and OpenCode.

I use this repo to keep the skills I care about versioned, installable, and consistent across machines. Most of them are working notes for engineering, architecture, planning, reviews, and writing.

## Install

Install everything for both agents:

```sh
make install
```

That copies the skills into:

- `~/.codex/skills`
- `~/.claude/skills`
- `~/.config/opencode/skills`

Install for just one agent:

```sh
make install-codex
make install-claude
make install-opencode
```

Or point either target somewhere else:

```sh
make install-codex CODEX_SKILLS_DIR=/path/to/codex/skills
make install-claude CLAUDE_SKILLS_DIR=/path/to/claude/skills
make install-opencode OPENCODE_SKILLS_DIR=/path/to/opencode/skills
```

Each install wipes its destination directory first, so renames and deletions never leave anything behind. The destinations are assumed to be owned by this repo. `make uninstall` removes them.

Claude Code can invoke installed skills directly with `/skill-name`, and can also infer them when their descriptions match the task.

OpenCode discovers installed skills through its native `skill` tool.

Every skill's name and description sit in context in every session, whether or not the skill is used — only the body and references load on demand. Claude Code caps that always-loaded listing at a fraction of the context window (`skillListingBudgetFraction`); past the cap, descriptions get truncated or dropped and routing degrades. Keeping the set small and the descriptions situational is what keeps that budget comfortable.

## Skills

Engineering:

- `engineer` — write or review code; per-language references load on demand
- `architecture` — survey for shallow modules and design the replacement interface
- `diagnose` — disciplined loop for hard bugs and performance regressions
- `distributed-systems` — plan, review, or drill a distributed design

Planning and project work:

- `grill-me` — interrogate a plan against the project's domain language and ADRs
- `prd` — synthesize a feature's intent into a PRD and publish it
- `issues` — break an approved plan into vertical slices and publish them
- `triage` — move tracker issues through the triage state machine; also repo setup

Writing:

- `humanize` — make existing prose read as though a person wrote it
- `marketing-copywriter` — write, critique, and QA marketing assets

Each skill states its own default failure mode and the rules that counter it. Guidance that merely restates what a capable model already does earns no place here; guidance that pulls against the most common pattern is the entire point.

## Credits

Some of these skills are adapted from Matt Pocock's [Skills For Real Engineers](https://github.com/mattpocock/skills) — `diagnose` and `grill-me` directly, `architecture` (formerly `improve-codebase-architecture`), and the tracker skills `triage`, `issues` (formerly `to-issues`), and `prd` (formerly `to-prd`), which also absorbed `setup-project`.

Matt's skills repo is MIT licensed. See [THIRD_PARTY_NOTICES.md](./THIRD_PARTY_NOTICES.md) for the upstream notice.
