CODEX_SKILLS_DIR ?= $(HOME)/.codex/skills
CLAUDE_SKILLS_DIR ?= $(HOME)/.claude/skills
SKILLS := $(shell find . -mindepth 2 -maxdepth 2 -name SKILL.md -exec dirname {} \; | sed 's|^\./||' | sort)

.PHONY: install install-codex install-claude list

install: install-codex install-claude

install-codex:
	@mkdir -p "$(CODEX_SKILLS_DIR)"
	@for skill in $(SKILLS); do \
		echo "Installing $$skill -> $(CODEX_SKILLS_DIR)/$$skill"; \
		rm -rf "$(CODEX_SKILLS_DIR)/$$skill"; \
		cp -R "$$skill" "$(CODEX_SKILLS_DIR)/"; \
	done

install-claude:
	@mkdir -p "$(CLAUDE_SKILLS_DIR)"
	@for skill in $(SKILLS); do \
		echo "Installing $$skill -> $(CLAUDE_SKILLS_DIR)/$$skill"; \
		rm -rf "$(CLAUDE_SKILLS_DIR)/$$skill"; \
		cp -R "$$skill" "$(CLAUDE_SKILLS_DIR)/"; \
		rm -rf "$(CLAUDE_SKILLS_DIR)/$$skill/agents"; \
	done

list:
	@printf '%s\n' $(SKILLS)
