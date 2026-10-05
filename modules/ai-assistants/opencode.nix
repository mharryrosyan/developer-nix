{
  config,
  pkgs,
  lib,
  ...
}: let
  opencodeConfig = builtins.toJSON {
    version = "1.0";
    editor = {
      defaultMode = "plan"; # Default to plan/review mode for safety
    };
    rules = [
      "Follow corporate safety guidelines in ~/.config/ai-rules/company-safety.md"
    ];
  };
in {
  home.file.".config/opencode/config.json".text = opencodeConfig;

  home.activation.setupOpencodeDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.config/opencode/skills"
  '';
}
