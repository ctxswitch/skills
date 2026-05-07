# Skills

My personal skills for Codex and Claude Code.

I use this repo to keep the skills I care about versioned, installable, and consistent across machines. Most of them are working notes for engineering, architecture, planning, reviews, and writing.

## Install

Install everything for both agents:

```sh
make install
```

That copies the skills into:

- `~/.codex/skills`
- `~/.claude/skills`

Install for just one agent:

```sh
make install-codex
make install-claude
```

Or point either target somewhere else:

```sh
make install-codex CODEX_SKILLS_DIR=/path/to/codex/skills
make install-claude CLAUDE_SKILLS_DIR=/path/to/claude/skills
```

The install targets replace matching skill directories in the destination and leave unrelated directories alone.

Claude Code can invoke installed skills directly with `/skill-name`, and can also infer them when their descriptions match the task.

Recent Claude Code builds use a small skill listing budget, currently 1% of context by default. When the installed skills exceed that budget, Claude may warn, truncate descriptions, or silently drop some descriptions from the inferred skill list. The current install reports about 1.4k skill-listing tokens, which is roughly 1.1% of a 128k context; trimming further would start cutting trigger language the skills need to infer correctly.

## Skills

Engineering:

- `go-engineer`
- `go-reviewer`
- `python-engineer`
- `python-reviewer`
- `rust-engineer`
- `rust-reviewer`
- `typescript-engineer`
- `typescript-reviewer`
- `tdd`

Architecture, planning, and project work:

- `diagnose`
- `distributed-systems-planner`
- `drill-me`
- `grill-me`
- `improve-codebase-architecture`
- `setup-project`
- `to-issues`
- `to-prd`
- `triage`
- `zoom-out`

Writing:

- `humanize`
- `marketing-copywriter`

## Credits

Some of these skills are adapted from Matt Pocock's [Skills For Real Engineers](https://github.com/mattpocock/skills), especially `diagnose`, `grill-me`, `improve-codebase-architecture`, `setup-project`, `to-issues`, `to-prd`, and `triage`.

Matt's skills repo is MIT licensed. See [THIRD_PARTY_NOTICES.md](./THIRD_PARTY_NOTICES.md) for the upstream notice.
