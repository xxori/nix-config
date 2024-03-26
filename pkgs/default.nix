{pkgs,...}: {
  # cosmocc = pkgs.callPackage ./cosmocc.nix {};
  # uiua = pkgs.callPackage ./uiua.nix { };
  # harec = pkgs.callPackage ./harec.nix { };
  # AudioToolbox = pkgs.darwin.apple_sdk.frameworks.AudioToolbox;
  # Cocoa = pkgs.darwin.apple_sdk.frameworks.Cocoa;
  # CoreFoundation = pkgs.darwin.apple_sdk.frameworks.CoreFoundation;
  # OpenGL = pkgs.darwin.apple_sdk.frameworks.OpenGL;
  # Foundation = pkgs.darwin.apple_sdk.frameworks.Foundation;
  # ForceFeedback = pkgs.darwin.apple_sdk.frameworks.ForceFeedback;
  # hare = pkgs.callPackage ./hare.nix { inherit harec; };
  # lobster = pkgs.callPackage ./lobster.nix { inherit AudioToolbox; inherit Cocoa; inherit CoreFoundation; inherit OpenGL; inherit Foundation; inherit ForceFeedback; } ;
  texpresso = pkgs.callPackage ./texpresso.nix {};
}
