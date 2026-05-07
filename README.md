# ctxswitch skills

My personal Codex skills.

This repo leaves out Codex's built-in `.system/` skills. It only includes the custom skills I want to keep under version control and install across machines.

## Install

Install the skills into the default Codex skills directory:

```sh
make install
```

Or point the install somewhere else:

```sh
make install CODEX_SKILLS_DIR=/path/to/skills
```

`make install` replaces matching skill directories in the destination. It leaves unrelated directories alone, including `.system`.

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
