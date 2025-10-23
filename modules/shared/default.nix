{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  nix.settings = {
    trusted-users = ["root" "patrick"];
    allowed-users = ["@admin" "patrick"];
    auto-optimise-store = false;

    substituters = ["https://cache.nixos.org" "https://nix-community.cachix.org" "https://cache.garnix.io"];
    trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
    trusted-substituters = ["https://cache.nixos.org" "https://nix-community.cachix.org" "https://cache.garnix.io"];
  };
  nix.optimise.automatic = true;
  nix.package = pkgs.lix;
  #nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  services.emacs.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [outputs.overlays.default inputs.nix-vscode-extensions.overlays.default];
}
