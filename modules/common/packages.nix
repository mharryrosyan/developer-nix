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

    # Security & Secret Scanning
    gitleaks
    trufflehog

    # Nix helpers & code formatters
    nh
    nix-output-monitor
    alejandra
  ];
}
