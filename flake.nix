{
  description = "Standardized Developer Platform & AI Guardrails Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin for macOS system-level management (optional for macOS devs)
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      # Supported architecture systems
      linuxSystem = "x86_64-linux";
      darwinArmSystem = "aarch64-darwin";
      darwinIntelSystem = "x86_64-darwin";

      # Shared modules for all developer workstations
      commonModules = [
        ./modules/common
        ./modules/security
        ./modules/ai-assistants
        ./modules/autonomous-agents
        ./modules/mcp
      ];
    in {
      # 1. Linux & Windows WSL2 Workstations
      homeConfigurations."developer-linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = linuxSystem;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./hosts/linux.nix
        ];
      };

      # 2. Apple Silicon macOS (M1/M2/M3/M4) Workstations
      homeConfigurations."developer-darwin-arm" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = darwinArmSystem;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./hosts/darwin.nix
        ];
      };

      # 3. Intel Mac Workstations
      homeConfigurations."developer-darwin-x86" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = darwinIntelSystem;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./hosts/darwin.nix
        ];
      };
    };
}
