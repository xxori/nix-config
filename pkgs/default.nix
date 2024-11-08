{pkgs, ...}: {
  texpresso = pkgs.callPackage ./texpresso.nix {};
  berkeley = pkgs.callPackage ./berkeley.nix {};
}
