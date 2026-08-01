CODEX_SKILLS_DIR ?= $(HOME)/.codex/skills
CLAUDE_SKILLS_DIR ?= $(HOME)/.claude/skills
OPENCODE_SKILLS_DIR ?= $(HOME)/.config/opencode/skills
SKILLS := $(shell find . -mindepth 2 -maxdepth 2 -name SKILL.md -exec dirname {} \; | sed 's|^\./||' | sort)

# Each install wipes its destination first, so renames and deletions never
# leave anything behind. The destination is assumed to be owned by this repo.
.PHONY: install install-codex install-claude install-opencode uninstall list

install: install-codex install-claude install-opencode

install-codex:
	@rm -rf "$(CODEX_SKILLS_DIR)"
	@mkdir -p "$(CODEX_SKILLS_DIR)"
	@for skill in $(SKILLS); do \
		echo "Installing $$skill -> $(CODEX_SKILLS_DIR)/$$skill"; \
		cp -R "$$skill" "$(CODEX_SKILLS_DIR)/"; \
	done

install-claude:
	@rm -rf "$(CLAUDE_SKILLS_DIR)"
	@mkdir -p "$(CLAUDE_SKILLS_DIR)"
	@for skill in $(SKILLS); do \
		echo "Installing $$skill -> $(CLAUDE_SKILLS_DIR)/$$skill"; \
		cp -R "$$skill" "$(CLAUDE_SKILLS_DIR)/"; \
		rm -rf "$(CLAUDE_SKILLS_DIR)/$$skill/agents"; \
	done

install-opencode:
	@rm -rf "$(OPENCODE_SKILLS_DIR)"
	@mkdir -p "$(OPENCODE_SKILLS_DIR)"
	@for skill in $(SKILLS); do \
		echo "Installing $$skill -> $(OPENCODE_SKILLS_DIR)/$$skill"; \
		cp -R "$$skill" "$(OPENCODE_SKILLS_DIR)/"; \
		rm -rf "$(OPENCODE_SKILLS_DIR)/$$skill/agents"; \
	done

uninstall:
	@rm -rf "$(CODEX_SKILLS_DIR)" "$(CLAUDE_SKILLS_DIR)" "$(OPENCODE_SKILLS_DIR)"
	@echo "Removed $(CODEX_SKILLS_DIR), $(CLAUDE_SKILLS_DIR), $(OPENCODE_SKILLS_DIR)"

list:
	@printf '%s\n' $(SKILLS)
