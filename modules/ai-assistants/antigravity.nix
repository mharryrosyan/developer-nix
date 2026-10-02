{ config, pkgs, lib, ... }:

let
  # Safe default config for Antigravity
  antigravityConfig = builtins.toJSON {
    version = "1.0";
    settings = {
      theme = "dark";
      modelSelection = "Gemini 3.8 Flash (High)";
    };
    permissions = {
      allow = [
        "command(which)"
        "command(ls)"
        "command(git status)"
        "command(git diff)"
      ];
      deny = [
        "command(rm -rf /)"
        "command(git push --force origin main)"
      ];
      ask = [
        "command(rm -rf *)"
        "command(drop database*)"
      ];
    };
  };
in {
  # Standardize base config.json for Antigravity
  home.file.".gemini/config/config.json".text = antigravityConfig;

  # Ensure user local directories exist
  home.activation.setupAntigravityDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.gemini/config/skills"
    mkdir -p "$HOME/.gemini/config/plugins"
    mkdir -p "$HOME/.gemini/rules"
  '';
}
