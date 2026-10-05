{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./openclaw.nix
    ./hermes.nix
  ];
}
