# AGENT.md — Developer Platform & AI Guardrails (`developer-nix`)

Welcome, Agent. This document provides the complete context, architectural blueprint, operational rules, and security boundaries for working in the **`developer-nix`** repository.

---

## 1. Project Mission & Context

**`developer-nix`** is an internal, organization-wide configuration repository managed via **Nix Flakes** and **Home Manager**. 

### Primary Objectives:
1. **Total Reproducibility:** Ensure every developer workstation across the company (Linux, macOS, and Windows via WSL2) runs identical, deterministic toolchains, shell configurations, and developer utilities.
2. **AI Tooling Standardization:** Standardize configurations, rules, and skills for interactive coding assistants (*Antigravity*, *Kiro-CLI*, *OpenCode*) and autonomous reasoning engines (*OpenClaw*, *Hermes Agent*).
3. **Data Privacy & Zero-Trust Security:** Prevent AI coding agents from leaking corporate credentials, API keys, private keys, or customer Personally Identifiable Information (PII) to public LLM APIs.
4. **Declarative Updates & Rollbacks:** Changes are made in this Git repository, pushed, pulled, and applied atomically via `home-manager switch`. Broken configurations can be rolled back in seconds.

---

## 2. Repository Layout & Architecture

```text
developer-nix/
├── flake.nix                       # Main entrypoint: inputs, outputs, targets, and formatter
├── AGENT.md                        # Context and instructions for AI Agents (this file)
├── README.md                       # Human-facing onboarding and operational manual
├── .gitlab-ci.yml                  # CI pipeline for internal GitLab (flake check & lint)
├── .github/workflows/ci.yml        # CI pipeline for GitHub (flake check & lint)
├── hosts/
│   ├── linux.nix                   # Host profile for Linux and Windows WSL2
│   └── darwin.nix                  # Host profile for macOS (Apple Silicon & Intel)
├── modules/
│   ├── ai-assistants/              # 1. Interactive Coding Assistants
│   │   ├── antigravity.nix         # Antigravity CLI configs, permissions, directory bootstrap
│   │   ├── kiro.nix                # Kiro-CLI configuration and diff safety
│   │   ├── opencode.nix            # OpenCode settings (default mode: plan)
│   │   └── default.nix             # Aggregator
│   ├── autonomous-agents/          # 2. Autonomous Reasoning & Execution
│   │   ├── openclaw.nix            # OpenClaw workspace and gateway configuration
│   │   ├── hermes.nix              # Hermes agent reasoning profiles and logs
│   │   └── default.nix             # Aggregator
│   ├── mcp/                        # 3. Model Context Protocol (MCP) Standard Servers
│   │   └── default.nix             # GitLab, Jira, DBX, Codebase Memory (excludes personal MCPs)
│   ├── security/                   # 4. Guardrails & Credential Protection
│   │   ├── guardrails.nix          # Global ignore rules (.geminiignore, .cursorignore, etc.)
│   │   ├── rules/
│   │   │   └── company-safety.md   # System prompt rules: anti-PII & secret isolation
│   │   ├── secrets-template.nix    # Automated ~/.config/company-ai/secrets.env template
│   │   └── default.nix             # Aggregator
│   ├── skills/                     # 5. Centralized Skills Catalog
│   │   ├── catalog/
│   │   │   ├── code-reviewer/      # Skill: Code hygiene, edge cases, bug catching
│   │   │   ├── security-auditor/   # Skill: OWASP Top 10, SQL injection, PII scanning
│   │   │   └── api-standards/      # Skill: REST API envelope and idempotency standards
│   │   └── default.nix             # Distributes skills across Antigravity, OpenCode, OpenClaw
│   └── common/                     # 6. Core Toolchain & Developer Experience
│       ├── packages.nix            # Modern CLI tools, gitleaks, trufflehog, alejandra
│       ├── git.nix                 # Standard git configs + pre-commit secret hook
│       ├── shell.nix               # Zsh plugins, direnv, starship prompt, and aliases
│       └── default.nix             # Aggregator
└── scripts/
    ├── install-nix.sh              # 1-line onboarding script
    ├── sync.sh                     # Helper script: git pull & switch (alias: dev-sync)
    └── rollback.sh                 # Helper script: instant rollback (alias: dev-rollback)
```

---

## 3. Strict Security Guardrails (Agent Invariants)

When editing or proposing changes in this repository, you **MUST** strictly uphold these invariants:

1. **NEVER Expose or Commit Secrets:**
   - Under no circumstances should tokens, credentials, or private keys be committed to this repo.
   - All secret credentials belong in `~/.config/company-ai/secrets.env` (which is excluded from Git and AI context).
2. **Never Weaken Ignore Files:**
   - Do NOT remove `.env`, `secrets.env`, `*.pem`, `id_rsa*`, or `/data/pii/` from `modules/security/guardrails.nix`.
   - Any AI tool configuration generated must inherit or point to `modules/security/rules/company-safety.md`.
3. **Pre-commit Hook Protection:**
   - Git commits are guarded by `gitleaks` via `modules/common/git.nix`. Never disable or bypass this hook.
4. **Database Tooling Limits:**
   - Database MCP configurations (`dbx`) must remain restricted to read-only queries on staging/dev sandboxes. Never configure direct write credentials to production databases.

---

## 4. How Configurations are Applied

Nix operates **declaratively and immutably**:
1. Files defined in Home Manager (via `home.file` or `xdg.configFile`) are placed into `/nix/store/<hash>-...` as **read-only** files.
2. They are then **symlinked** into the developer's `$HOME` (e.g. `~/.gemini/config/mcp_config.json` -> `/nix/store/...`).
3. **DO NOT edit symlinked config files directly in `$HOME`.** They will be overwritten or error out with permission denied.
4. To make a change:
   - Edit the appropriate Nix module inside this repository.
   - Run `nix fmt` to ensure clean formatting.
   - Run `home-manager switch --flake .#<target>` (or run `./scripts/sync.sh` / `dev-sync`).

---

## 5. Adding New Components (Guidelines for Agents)

### A. Adding an Interactive AI Assistant
1. Create `modules/ai-assistants/<tool-name>.nix`.
2. Configure settings, default modes (prefer `plan` or `review` before execution), and inject `company-safety.md`.
3. Import the file in `modules/ai-assistants/default.nix`.

### B. Adding an Autonomous Agent Engine
1. Create `modules/autonomous-agents/<agent-name>.nix`.
2. Configure workspace isolation (e.g. `~/.<agent>/workspace`), sandboxing, and session logs.
3. Import the file in `modules/autonomous-agents/default.nix`.

### C. Adding a Team MCP Server
1. Update `modules/mcp/default.nix`.
2. Ensure the command wraps credential loading safely:
   ```nix
   args = [
     "-c"
     "[ -f ~/.config/company-ai/secrets.env ] && . ~/.config/company-ai/secrets.env; exec <server-binary>"
   ];
   ```
3. **Policy Notice:** Do NOT include personal developer MCP servers (e.g. `indexqums`). Only shared team infrastructure belongs here.

### D. Adding a New Team Skill
1. Create a folder in `modules/skills/catalog/<skill-name>/SKILL.md`.
2. Provide YAML frontmatter (`name`, `description`) and clear operational guidance.
3. Symlink the skill folder to agent target paths in `modules/skills/default.nix`.

---

## 6. Code Style & Verification

- **Formatter:** Always run `nix fmt` (powered by `alejandra`) before committing changes.
- **Git Commits:** Follow semantic commit messages (`feat:`, `fix:`, `refactor:`, `chore:`).
- **Flake Validation:** Validate configurations with `nix flake check` or CI checks.
