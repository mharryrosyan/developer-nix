{
  config,
  pkgs,
  lib,
  ...
}: let
  kiroConfig = builtins.toJSON {
    version = "1.0";
    safety = {
      autoCommit = false;
      reviewDiff = true;
    };
    rulesFile = "~/.config/ai-rules/company-safety.md";
  };
in {
  home.file.".config/kiro/config.json".text = kiroConfig;

  home.activation.setupKiroDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.config/kiro"
  '';
}
