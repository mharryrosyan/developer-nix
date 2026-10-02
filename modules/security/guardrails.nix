{ config, pkgs, lib, ... }:

let
  ignorePatterns = ''
    # Environment & Secrets
    .env
    .env.*
    *.env
    secrets.env
    *.pem
    *.key
    id_rsa*
    *.p12
    *.pfx
    *.keystore

    # Credentials & Cloud Tokens
    .aws/credentials
    .gcp/
    .kube/config
    service-account*.json

    # Company Secrets Directory
    .config/company-ai/**

    # Sensitive Database & Data Dumps
    *.sql.gz
    *.dump
    dumps/
    /data/pii/
    /data/customer/
  '';
in {
  # 1. Global Git Ignore
  programs.git.ignores = [
    "*.env"
    "secrets.env"
    "*.pem"
    "*.key"
    "id_rsa*"
    "service-account*.json"
    ".config/company-ai/"
    "*.dump"
    "*.sql.gz"
  ];

  # 2. Global AI Ignore Files (Read-only symlinks from Nix store)
  home.file.".geminiignore".text = ignorePatterns;
  home.file.".cursorignore".text = ignorePatterns;
  home.file.".aiderignore".text = ignorePatterns;
  home.file.".config/opencode/.ignore".text = ignorePatterns;

  # 3. Global Corporate Safety Rules for AI
  home.file.".gemini/rules/company-safety.md".source = ./rules/company-safety.md;
  home.file.".config/ai-rules/company-safety.md".source = ./rules/company-safety.md;
}
