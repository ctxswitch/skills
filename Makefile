CODEX_SKILLS_DIR ?= $(HOME)/.codex/skills
SKILLS := $(shell find . -mindepth 2 -maxdepth 2 -name SKILL.md -exec dirname {} \; | sed 's|^\./||' | sort)

.PHONY: install list

install:
	@mkdir -p "$(CODEX_SKILLS_DIR)"
	@for skill in $(SKILLS); do \
		echo "Installing $$skill -> $(CODEX_SKILLS_DIR)/$$skill"; \
		rm -rf "$(CODEX_SKILLS_DIR)/$$skill"; \
		cp -R "$$skill" "$(CODEX_SKILLS_DIR)/"; \
	done

list:
	@printf '%s\n' $(SKILLS)
