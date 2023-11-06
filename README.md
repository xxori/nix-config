# Nix declarative config files for macos
---
Nix config files to manage applications and configurations using home-manager and darwin.

### Use
Install nix
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
Install home-manager
```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update
```
Build the flake (and nix-darwin) for the first time:
```sh
nix build .#darwinConfigurations.patrick-mac --extra-experimental-features "nix-command flakes"
./result/sw/bin/darwin-rebuild switch --flake .
```
Now everything should be installed and in path, so we can update with ``darwin-rebuild switch --flake PATH_TO_REPO`` or using ``dr`` alias.