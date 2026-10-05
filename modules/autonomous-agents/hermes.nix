{
  config,
  pkgs,
  lib,
  ...
}: let
  hermesConfig = builtins.toJSON {
    version = "1.0";
    reasoning = {
      defaultMode = "plan_and_execute";
      maxIterations = 20;
    };
    environment = {
      rulesPath = "~/.config/ai-rules/company-safety.md";
      strictSecrets = true;
    };
  };
in {
  home.file.".hermes/config.json".text = hermesConfig;

  home.activation.setupHermesDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.hermes/sessions"
    mkdir -p "$HOME/.hermes/logs"
  '';
}
