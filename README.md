# Standardized Developer Platform & AI Guardrails (`developer-nix`)

Repository konfigurasi terpusat untuk seluruh tim developer menggunakan **Nix Flakes** dan **Home Manager**. Mendukung **Linux**, **macOS (Apple Silicon & Intel)**, dan **Windows 10/11 (via WSL2)**.

---

## 🎯 Tujuan Utama

1. **Standardisasi Lingkungan Kerja:** Menghilangkan *"it works on my machine"*. Seluruh developer memiliki versi tools, shell, dan ekstensi yang identik.
2. **AI Agent Guardrails:** Mencegah kebocoran data sensitif (PII nasabah/pelanggan), token API, dan private key ke cloud LLM.
3. **Pemisahan AI Tools:**
   - **Interactive Coding Assistants:** Antigravity CLI (`agy`), Kiro-CLI, OpenCode.
   - **Autonomous Reasoning Agents:** OpenClaw, Hermes Agent.
4. **Sentralisasi MCP Tools:** Menghubungkan seluruh tim ke server MCP standar (`gitlab`, `jira`, `dbx`, `codebase-memory`), tanpa mencampurkan MCP personal developer.
5. **Atomic Updates & Instant Rollback:** Update konfigurasi cukup dengan `dev-sync`. Jika ada error, rollback dalam 2 detik dengan `dev-rollback`.

---

## 📂 Struktur Repositori

```text
developer-nix/
├── flake.nix                       # Entry point Nix Flakes (multi-platform outputs)
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
│   └── common/                     # Core Developer Toolchain
│       ├── packages.nix            # CLI utilities (ripgrep, fd, jq, bat, fzf, lazygit)
│       ├── git.nix                 # Git standard configurations
│       └── shell.nix               # Starship prompt & aliases (dev-sync, dev-rollback)
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

> ⚠️ **Catatan Keamanan:** File `secrets.env` ini secara otomatis **DIBLOKIR** oleh Nix dari Git dan AI Agent (`.geminiignore`, `.cursorignore`). Agent tidak akan pernah bisa membaca isi file ini.

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

### Melihat Riwayat Generasi Konfigurasi
```bash
dev-generations
```
