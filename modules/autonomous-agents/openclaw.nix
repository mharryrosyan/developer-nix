{
  config,
  pkgs,
  lib,
  ...
}: let
  openclawConfig = builtins.toJSON {
    version = "1.0";
    agent = {
      workspace = "~/.openclaw/workspace";
      maxSubagents = 4;
      sandbox = true;
    };
    security = {
      rulesFile = "~/.config/ai-rules/company-safety.md";
      disallowDirectExecutionWithoutConfirmation = [
        "deploy"
        "terraform"
        "drop"
      ];
    };
  };
in {
  home.file.".openclaw/config.json".text = openclawConfig;

  home.activation.setupOpenclawWorkspace = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.openclaw/workspace"
    mkdir -p "$HOME/.openclaw/skills"
  '';
}
