{ config, pkgs, lib, ... }:

{
  imports = [
    ./guardrails.nix
    ./secrets-template.nix
  ];
}
