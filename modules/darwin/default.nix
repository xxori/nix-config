{
  outputs,
  pkgs,
  ...
}: let
  user = "patrick";
  sharedProgs = import ../shared/home-manager.nix {inherit pkgs;};
in {
  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  system.stateVersion = 5;
  programs.zsh.enable = true;
  imports = [
    ../shared
  ];

  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    casks = [
      # GUI Apps
      "tailscale"
      "discord"
      "qbittorrent"
      "raycast"
      "prismlauncher"
      "orbstack"
      "gpg-suite-no-mail"
      "obsidian"
      "steam"
      "calibre"
      "spotify"
      "android-studio"
    ];
  };

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
  };

  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;
  home-manager.users.${user} = {
    config,
    pkgs,
    ...
  }: {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "${user}";
    home.homeDirectory = "/Users/${user}";
    xdg.cacheHome = "/Users/${user}/.local/cache";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # Some of these should probably be system packages...
    home.packages = import ../shared/packages.nix {inherit pkgs;};

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = import ../shared/files.nix {};

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [outputs.overlays.default];

    #programs.sioyek.enable = true;
    #programs.sioyek.bindings = {
    #  "zoom_in" = "J";
    #  "zoom_out" = "K";
    #};
    programs =
      sharedProgs
      // {
        zsh =
          sharedProgs.zsh
          // {
            initExtra =
              sharedProgs.zsh.initExtra
              + ''
                source $HOME/.orbstack/shell/init.zsh 2>/dev/null || :
                eval $(/opt/homebrew/bin/brew shellenv)
                eval $(orbctl completion zsh)
                fpath+=("$(brew --prefix)/share/zsh/site-functions")
              '';
            shellAliases =
              sharedProgs.zsh.shellAliases
              // {
                tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
                ghostty = "/Applications/Ghostty.app/Contents/MacOs/ghostty";
                dr = "darwin-rebuild switch --flake ~s/nix-config/";
              };
            dirHashes =
              sharedProgs.zsh.dirHashes
              // {
                ua = "$HOME/Applications";
                a = "/Applications";
              };
          };
      };
  };
}
