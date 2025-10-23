{vscode,fetchzip,...}
: 
  (vscode.overrideAttrs (oldAttrs: rec {
    src = (builtins.fetchTarball {
      url = "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal";
      sha256 = "0ydbhn6k5iz8n0ai3rjw6awhmmjsyzgr88vknslvh8w7vqiqfxy6";
    });
    version = "latest";
  }))

