{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./antigravity.nix
    ./opencode.nix
    ./kiro.nix
  ];
}
