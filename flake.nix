{
  description = "Nix configuration for NixOS and nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # ghostty = {
    # url = "git+ssh://git@github.com/ghostty-org/ghostty";
    # inputs.nixpkgs-stable.follows = "nixpkgs";
    # inputs.nixpkgs-unstable.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    darwin,
    # ghostty,
  } @ inputs: let
    inherit (self) outputs;
    systems = ["aarch64-darwin" "x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    overlays = import ./overlays {inherit inputs;};
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    darwinConfigurations."patrick-mac" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ./modules/darwin
      ];
      specialArgs = {inherit inputs outputs;};
    };
    nixosConfigurations."patrick-pc" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        ./modules/nixos
      ];
      specialArgs = {inherit inputs outputs;};
    };
  };
}
