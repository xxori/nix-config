{vscode,fetchzip,...}
: 
  (vscode.override{isInsiders=true;}).overrideAttrs (oldAttrs: rec {
    src = (builtins.fetchTarball {
      url = "https://code.visualstudio.com/sha/download?build=insider&os=darwin-universal";
      sha256 = "sha256-2v8Ak/HeqI2SYKzGOs43/sZQlfPhCOxmErFlZn2gBvo=";
    });
    version = "latest";
  })

