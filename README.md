# ctxswitch skills

Personal Codex skills used by ctxswitch.

This repository intentionally excludes Codex system skills from `.system/`. It only contains custom skills that can be installed into a local Codex home.

## Install

Install all skills into `~/.codex/skills`:

```sh
make install
```

To install somewhere else:

```sh
make install CODEX_SKILLS_DIR=/path/to/skills
```

The install target replaces matching skill directories in the destination and leaves unrelated directories, including `.system`, alone.

## Skills

- `diagnose`
- `distributed-systems-planner`
- `drill-me`
- `go-engineer`
- `go-reviewer`
- `grill-me`
- `humanize`
- `improve-codebase-architecture`
- `setup-project`
- `tdd`
- `to-issues`
- `to-prd`
- `triage`
- `zoom-out`
