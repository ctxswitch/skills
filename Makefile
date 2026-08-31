CODEX_SKILLS_DIR ?= $(HOME)/.codex/skills
CLAUDE_SKILLS_DIR ?= $(HOME)/.claude/skills
OPENCODE_SKILLS_DIR ?= $(HOME)/.config/opencode/skills
SKILLS := $(shell find . -mindepth 2 -maxdepth 2 -type f -name .ctx-skills -exec dirname {} \; | sed 's|^\./||' | sort)

.PHONY: install install-codex install-claude install-opencode uninstall list

install: install-codex install-claude install-opencode

define install_skills
	@dest="$(1)"; \
	case "$$dest" in \
		""|"/"|"$(HOME)") echo "Refusing unsafe skills destination: $$dest" >&2; exit 1 ;; \
		/*) ;; \
		*) echo "Skills destination must be absolute: $$dest" >&2; exit 1 ;; \
	esac; \
	mkdir -p "$$dest"; \
	for marker in "$$dest"/*/.ctx-skills; do \
		[ -f "$$marker" ] || continue; \
		skill_dir=$${marker%/.ctx-skills}; \
		skill=$${skill_dir##*/}; \
		case " $(SKILLS) " in \
			*" $$skill "*) ;; \
			*) echo "Removing $$skill from $$dest"; rm -rf "$$skill_dir" ;; \
		esac; \
	done; \
	for skill in $(SKILLS); do \
		rm -rf "$$dest/$$skill"; \
		echo "Installing $$skill -> $$dest/$$skill"; \
		cp -R "$$skill" "$$dest/"; \
		if [ "$(2)" = "without-agents" ]; then rm -rf "$$dest/$$skill/agents"; fi; \
	done
endef

define uninstall_skills
	@dest="$(1)"; \
	case "$$dest" in \
		""|"/"|"$(HOME)") echo "Refusing unsafe skills destination: $$dest" >&2; exit 1 ;; \
		/*) ;; \
		*) echo "Skills destination must be absolute: $$dest" >&2; exit 1 ;; \
	esac; \
	if [ -d "$$dest" ]; then \
		for marker in "$$dest"/*/.ctx-skills; do \
			[ -f "$$marker" ] || continue; \
			skill_dir=$${marker%/.ctx-skills}; \
			echo "Removing $${skill_dir##*/} from $$dest"; \
			rm -rf "$$skill_dir"; \
		done; \
	fi
endef

install-codex:
	$(call install_skills,$(CODEX_SKILLS_DIR),with-agents)

install-claude:
	$(call install_skills,$(CLAUDE_SKILLS_DIR),without-agents)

install-opencode:
	$(call install_skills,$(OPENCODE_SKILLS_DIR),without-agents)

uninstall:
	$(call uninstall_skills,$(CODEX_SKILLS_DIR))
	$(call uninstall_skills,$(CLAUDE_SKILLS_DIR))
	$(call uninstall_skills,$(OPENCODE_SKILLS_DIR))

list:
	@printf '%s\n' $(SKILLS)
