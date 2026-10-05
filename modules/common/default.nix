{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./packages.nix
    ./git.nix
    ./shell.nix
  ];
}
