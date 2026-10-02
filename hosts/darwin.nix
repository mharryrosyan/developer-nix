{ config, pkgs, lib, ... }:

let
  username = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
in {
  home.username = if username != "" then username else "developer";
  home.homeDirectory = if homeDir != "" then homeDir else "/Users/developer";

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
