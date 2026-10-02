{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Modern developer CLI utilities
    ripgrep
    fd
    jq
    yq
    bat
    fzf
    eza
    lazygit
    htop
    curl
    wget

    # Nix helpers
    nh
    nix-output-monitor
  ];
}
