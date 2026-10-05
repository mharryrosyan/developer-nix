{
  config,
  pkgs,
  ...
}: let
  preCommitHook = ''
    #!/usr/bin/env sh
    # Automated Secret & Credential Leakage Scanner
    if command -v gitleaks >/dev/null 2>&1; then
      echo "🔍 [Security] Scanning staged changes with Gitleaks..."
      if ! gitleaks protect --staged --verbose --redact; then
        echo ""
        echo "❌ [SECURITY ALERT] Gitleaks detected potential credentials, tokens, or PII in staged files!"
        echo "Commit has been blocked to prevent data leakage."
        echo "Please remove the secret from staged files before committing."
        exit 1
      fi
    fi
  '';
in {
  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "nano";
        autocrlf = "input";
        hooksPath = "~/.config/git/hooks";
      };
    };
  };

  # Enforce global pre-commit hook to scan all commits for secrets
  home.file.".config/git/hooks/pre-commit" = {
    text = preCommitHook;
    executable = true;
  };
}
