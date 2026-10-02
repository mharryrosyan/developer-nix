{ config, pkgs, ... }:

{
  # Zsh full configuration with plugins
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autocd = true;

    history = {
      size = 50000;
      save = 50000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
  };

  # Direnv + Nix-Direnv for project-level isolated environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$name]($style) ";
      };
    };
  };

  # Shell aliases for team workflow
  home.shellAliases = {
    # Nix & Team Sync
    dev-sync = "cd ~/.config/developer-nix && git pull && home-manager switch --flake . && cd -";
    dev-rollback = "home-manager switch --rollback";
    dev-generations = "home-manager generations";

    # Modern CLI shortcuts
    ls = "eza --icons";
    ll = "eza -l --icons";
    la = "eza -la --icons";
    cat = "bat --paging=never";
    lg = "lazygit";
  };
}
