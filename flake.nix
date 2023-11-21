{
  description = "Nix configuration for NixOS and nix-darwin";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    # home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay, home-manager, darwin }: {
    darwinConfigurations."patrick-mac" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ./mac/default.nix
        # ./rust.nix
      ];
      specialArgs = {inherit rust-overlay;};
    };

  };
}
