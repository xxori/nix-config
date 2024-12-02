{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  nix.settings = {
    trusted-users = ["root" "patric"];
    allowed-users = ["@admin" "patrick"];
    auto-optimise-store = false;

    substituters = ["https://cache.nixos.org" "https://nix-community.cachix.org"];
    trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
    trusted-substituters = ["https://cache.nixos.org" "https://nix-community.cachix.org"];
  };
  nix.optimise.automatic = true;
  nix.package = pkgs.lix;
  #nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [outputs.overlays.default];
}
