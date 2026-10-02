# Standardized Developer Platform & AI Guardrails (`developer-nix`)

Repository konfigurasi terpusat untuk seluruh tim developer menggunakan **Nix Flakes** dan **Home Manager**. Mendukung **Linux**, **macOS (Apple Silicon & Intel)**, dan **Windows 10/11 (via WSL2)**.

---

## 🎯 Fitur & Kemampuan Lengkap

1. **Standardisasi Lingkungan Kerja:**
   - Menghilangkan *"it works on my machine"*. Seluruh developer memiliki versi tools, shell, dan ekstensi yang identik via `flake.lock`.
   - **Shell Standar:** Zsh lengkap dengan autosuggestions, syntax highlighting, dan Starship prompt.
   - **Isolasi Project:** `direnv` + `nix-direnv` otomatis me-load runtime saat `cd` ke folder repositori.
2. **AI Agent Guardrails & Anti-Leak Data:**
   - **Zero PII Tolerance:** SOP korporat melarang pengiriman data pelanggan (NIK, kartu kredit, dump database) ke LLM.
   - **Enforced Global Ignore:** `.geminiignore`, `.cursorignore`, `.aiderignore` secara otomatis memblokir file `.env`, `secrets.env`, `*.pem`, `id_rsa*`, dan dump database.
   - **Pre-commit Secret Scanner:** `gitleaks` otomatis memblokir commit jika ada API key, token, atau data sensitif yang tidak sengaja ter-stage.
3. **Pemisahan AI Tools:**
   - **Interactive Coding Assistants:** Antigravity CLI (`agy`), Kiro-CLI, OpenCode.
   - **Autonomous Reasoning Agents:** OpenClaw, Hermes Agent.
4. **Sentralisasi MCP Tools:**
   - Menghubungkan seluruh tim ke server MCP standar (`gitlab`, `jira`, `dbx`, `codebase-memory`), tanpa mencampurkan MCP personal developer.
5. **Katalog Skill AI Terpusat (`modules/skills/`):**
   - Otomatis men-distribusikan skill standar perusahaan ke seluruh laptop:
     - `code-reviewer`: Standar review kode, hygiene, dan anti-pattern.
     - `security-auditor`: Audit keamanan OWASP Top 10, SQL injection, dan PII leakage.
     - `api-standards`: Standarisasi REST API conventions dan response envelopes.
6. **Atomic Updates & Instant Rollback:**
   - Update konfigurasi cukup dengan `dev-sync`.
   - Jika ada error, rollback dalam 2 detik dengan `dev-rollback`.
7. **CI/CD Quality Control:**
   - Dilengkapi `.gitlab-ci.yml` dan GitHub Actions untuk memvalidasi `nix flake check` dan format kode (`alejandra`).

---

## 📂 Struktur Repositori

```text
developer-nix/
├── flake.nix                       # Entry point Nix Flakes (multi-platform outputs & formatter)
├── .gitlab-ci.yml                  # CI pipeline untuk GitLab
├── .github/workflows/ci.yml        # CI pipeline untuk GitHub
├── AGENTS.md                       # Blueprint & aturan kerja untuk AI Agent
├── README.md                       # Panduan lengkap onboarding & daily workflow
├── hosts/
│   ├── linux.nix                   # Host profile untuk Linux & Windows WSL2
│   └── darwin.nix                  # Host profile untuk macOS
├── modules/
│   ├── ai-assistants/              # Interactive Coding Assistants
│   │   ├── antigravity.nix         # Antigravity CLI config, safe permissions
│   │   ├── kiro.nix                # Kiro-CLI settings
│   │   └── opencode.nix            # OpenCode plan & execution settings
│   ├── autonomous-agents/          # Autonomous Reasoning & Execution
│   │   ├── openclaw.nix            # OpenClaw workspace & gateway
│   │   └── hermes.nix              # Hermes agent settings & session logs
│   ├── mcp/                        # Standard Team MCP Servers
│   │   └── default.nix             # GitLab, Jira, DBX, Codebase Memory
│   ├── security/                   # Guardrails & Anti-Leak Rules
│   │   ├── guardrails.nix          # Global .geminiignore, .cursorignore, .gitignore
│   │   ├── rules/
│   │   │   └── company-safety.md   # Aturan keamanan data & anti-PII perusahaan
│   │   └── secrets-template.nix    # Otomatisasi template ~/.config/company-ai/secrets.env
│   ├── skills/                     # Centralized Skills Catalog
│   │   ├── catalog/
│   │   │   ├── code-reviewer/      # Skill review kode & bug catching
│   │   │   ├── security-auditor/   # Skill audit keamanan OWASP & PII
│   │   │   └── api-standards/      # Skill standarisasi REST API
│   │   └── default.nix             # Symlink skills ke Antigravity, OpenCode, OpenClaw
│   └── common/                     # Core Developer Toolchain
│       ├── packages.nix            # CLI utilities, gitleaks, trufflehog, alejandra
│       ├── git.nix                 # Git standard configurations + pre-commit secret hook
│       └── shell.nix               # Zsh plugins, direnv, starship prompt, aliases
└── scripts/
    ├── install-nix.sh              # 1-line bootstrap script untuk onboarding
    ├── sync.sh                     # Helper script untuk git pull & switch
    └── rollback.sh                 # Helper script untuk instant rollback
```

---

## 🚀 Panduan Onboarding Developer Baru

### 1. Menjalankan Bootstrap
Clone repository ini ke `~/.config/developer-nix` lalu jalankan installer:

```bash
git clone git@github.com:your-company/developer-nix.git ~/.config/developer-nix
cd ~/.config/developer-nix
./scripts/install-nix.sh
```

*(Script akan otomatis mendeteksi apakah laptop menggunakan Linux, macOS Apple Silicon, macOS Intel, atau Windows WSL2).*

### 2. Mengisi Kredensial Pribadi (Satu Kali Saja)
Nix otomatis membuat file rahasia lokal di `~/.config/company-ai/secrets.env` dengan permission `600` (hanya bisa dibaca oleh user bersangkutan). 

Buka file tersebut dan masukkan token pribadi kamu:
```bash
nano ~/.config/company-ai/secrets.env
```
Isi token:
* `GITLAB_TOKEN` (Personal Access Token GitLab kamu)
* `JIRA_API_TOKEN` & `JIRA_USER_EMAIL`

> 🛡️ **Catatan Keamanan:** File `secrets.env` ini secara otomatis **DIBLOKIR** oleh Nix dari Git dan AI Agent (`.geminiignore`, `.cursorignore`). Selain itu, pre-commit hook `gitleaks` aktif di git untuk mencegah token ter-commit secara tidak sengaja.

---

## 🔄 Workflow Harian

### Menarik Update dari Tim Lead
Jika tim lead menambahkan skill baru, merubah rules, atau mengupdate MCP:
```bash
dev-sync
```
*(Atau jalankan `./scripts/sync.sh`)*

### Melakukan Rollback jika Terjadi Kendala
Jika update baru menyebabkan masalah di laptop kamu:
```bash
dev-rollback
```
*(Sistem akan langsung kembali ke versi konfigurasi sebelumnya dalam 2 detik)*

### Format Kode Nix Otomatis
```bash
nix fmt
```
