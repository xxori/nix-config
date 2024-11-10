{
  stdenv,
  fetchgit,
  fcft,
  wayland,
  wayland-protocols,
  pkg-config,
  pixman,
  wayland-scanner,
}:
stdenv.mkDerivation {
  src = fetchgit {
    url = "https://codeberg.org/sewn/dam.git";
    rev = "1416d6be6cc211d6841e076340cc2ab6f2e381d5";
    hash = "sha256-pDb6xEaC6xZP3rtjrymUyuTrrOFhvNEvVbyFU9FobjU=";
  };
  name = "dam";
  version = "2024-10-28";
  nativeBuildInputs = [fcft wayland wayland-scanner wayland-protocols pkg-config pixman];
  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    sed -i -e "s|/usr/local|$out|g" Makefile
    cat Makefile
    make install

    runHook postInstall
  '';
}
