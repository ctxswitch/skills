# Skills

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

## Credits

Some of these skills are adapted from Matt Pocock's [Skills For Real Engineers](https://github.com/mattpocock/skills), especially `diagnose`, `grill-me`, `improve-codebase-architecture`, `setup-project`, `to-issues`, `to-prd`, and `triage`.

Matt's skills repo is MIT licensed. See [THIRD_PARTY_NOTICES.md](./THIRD_PARTY_NOTICES.md) for the upstream notice.
