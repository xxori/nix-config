{
  pkgs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "berkeleymono-nerd";
  version = "0.0.0";

  src = ./BerkeleyMono;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype *

    runHook postInstall
  '';
}
