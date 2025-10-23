{stdenv}:
stdenv.mkDerivation {
  pname = "stdc++-header";
  version = "1.0";

  src = ./stdcpp;

  installPhase = ''
    mkdir -p $out/include/bits
    cp bits/stdc++.h $out/include/bits/stdc++.h
  '';
}
