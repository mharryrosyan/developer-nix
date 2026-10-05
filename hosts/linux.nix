{
  config,
  pkgs,
  lib,
  ...
}: let
  username = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
in {
  home.username =
    if username != ""
    then username
    else "developer";
  home.homeDirectory =
    if homeDir != ""
    then homeDir
    else "/home/developer";

  # State version for Home Manager backward compatibility
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Linux & WSL2 specific packages/tweaks
  targets.genericLinux.enable = true;
}
