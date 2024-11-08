{
  lib,
  stdenv,
  SDL2,
  freetype,
  fetchgit,
  re2c,
  mupdf,
  mujs,
  gcc,
  leptonica,
  tesseract,
  libjpeg,
  harfbuzz,
  jbig2dec,
  openjpeg,
  gumbo,
  rustc,
  cargo,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "texpresso";
  version = "08d4ae8632ef0da349595310d87ac01e70f2c6ae";
  src = fetchgit {
    url = "https://github.com/let-def/texpresso";
    rev = version;
    hash = "sha256-qqM4o50YDepL4JYNyBNA9xcAdrFV4OjF287RjJuF9wY=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [cargo rustc gumbo openjpeg harfbuzz jbig2dec libjpeg gcc SDL2 freetype re2c mupdf mujs leptonica tesseract];
  meta = {
    license = lib.licenses.mit;
    mainProgram = "texpresso";
  };
  postInstall = '''';
  checkPhase = '''';
})
