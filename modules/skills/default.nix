{
  config,
  pkgs,
  lib,
  ...
}: {
  # Symlink standardized company skills into Antigravity
  home.file.".gemini/config/skills/code-reviewer".source = ./catalog/code-reviewer;
  home.file.".gemini/config/skills/security-auditor".source = ./catalog/security-auditor;
  home.file.".gemini/config/skills/api-standards".source = ./catalog/api-standards;

  # Symlink into OpenCode skills directory
  home.file.".config/opencode/skills/code-reviewer".source = ./catalog/code-reviewer;
  home.file.".config/opencode/skills/security-auditor".source = ./catalog/security-auditor;
  home.file.".config/opencode/skills/api-standards".source = ./catalog/api-standards;

  # Symlink into OpenClaw skills directory
  home.file.".openclaw/skills/code-reviewer".source = ./catalog/code-reviewer;
  home.file.".openclaw/skills/security-auditor".source = ./catalog/security-auditor;
  home.file.".openclaw/skills/api-standards".source = ./catalog/api-standards;
}
