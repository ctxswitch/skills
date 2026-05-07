# Skills

My personal Codex skills.

This repo leaves out Codex's built-in `.system/` skills. It only includes the custom skills I want to keep under version control and install across machines.

## Install

Install the skills for both Codex and Claude Code:

```sh
make install
```

That copies each skill into:

- `~/.codex/skills`
- `~/.claude/skills`

Install for just one agent:

```sh
make install-codex
make install-claude
```

Or point either install somewhere else:

```sh
make install-codex CODEX_SKILLS_DIR=/path/to/codex/skills
make install-claude CLAUDE_SKILLS_DIR=/path/to/claude/skills
```

The install targets replace matching skill directories in the destination. They leave unrelated directories alone, including `.system`.

Claude Code can invoke installed skills directly with `/skill-name`, and can also load them automatically when their descriptions match the task.

## Skills

- `diagnose`
- `distributed-systems-planner`
- `drill-me`
- `go-engineer`
- `go-reviewer`
- `grill-me`
- `humanize`
- `improve-codebase-architecture`
- `marketing-copywriter`
- `setup-project`
- `tdd`
- `to-issues`
- `to-prd`
- `triage`
- `zoom-out`

## Credits

Some of these skills are adapted from Matt Pocock's [Skills For Real Engineers](https://github.com/mattpocock/skills), especially `diagnose`, `grill-me`, `improve-codebase-architecture`, `setup-project`, `to-issues`, `to-prd`, and `triage`.

Matt's skills repo is MIT licensed. See [THIRD_PARTY_NOTICES.md](./THIRD_PARTY_NOTICES.md) for the upstream notice.
