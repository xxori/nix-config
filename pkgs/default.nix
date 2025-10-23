{pkgs, ...}: {
  berkeley = pkgs.callPackage ./berkeley.nix {};
  dam = pkgs.callPackage ./dam.nix {};
  cambalache = pkgs.callPackage ./cambalache.nix {};
  stdcpp = pkgs.callPackage ./stdcpp.nix {};
  chawan = pkgs.callPackage ./chawan.nix {};
  vscode-insiders = pkgs.callPackage ./vscode-insiders.nix {};
#  vscode-latest = pkgs.callPackage ./vscode-latest.nix {};
}
