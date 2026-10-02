{ config, pkgs, ... }:

{
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
