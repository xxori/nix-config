{pkgs, ...}: {
  berkeley = pkgs.callPackage ./berkeley.nix {};
  dam = pkgs.callPackage ./dam.nix {};
}
