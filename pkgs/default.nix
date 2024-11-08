{pkgs, ...}: {
  berkeley = pkgs.callPackage ./berkeley.nix {};
}
