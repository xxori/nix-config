{ pkgs, ... }:
{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  # services.nix-daemon.package = pkgs.nixFlakes;

  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    casks = [
      # GUI Apps
      "sioyek"
      "qbittorrent"
      "raycast"
      "prismlauncher"
      "orbstack"
      "mactex-no-gui"
      "wineskin"
      "iina"
      "gpg-suite-no-mail"
      "obsidian"
      "steam"
      "spotify"
    ];
  };

  users.users.patrick = {
    name = "patrick";
    home = "/Users/patrick";
  };
  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;
  home-manager.users.patrick = { config, pkgs, ... }:

    {
      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = "patrick";
      home.homeDirectory = "/Users/patrick";
      xdg.cacheHome = "/Users/patrick/.local/cache";

      # Allow unfree software
      nixpkgs.config.allowUnfree = true;

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "23.05"; # Please read the comment before changing.

      # The home.packages option allows you to install Nix packages into your
      # environment.
      home.packages = with pkgs; [
        rnix-lsp
        android-tools
        gleam
        exercism
        ffmpeg
        neovim
        bun
        nodejs
        wget
        gh
        hugo
        ncdu
        wget
        python311
        fh
        fzf
        pure-prompt
        lsd
        zsh-autocomplete


        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
      ] ++ (with pkgs.python311Packages; [
        pip
      ]);

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      };

      # You can also manage environment variables but you will have to manually
      # source
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/patrick/etc/profile.d/hm-session-vars.sh
      #
      # if you don't want to manage your shell through Home Manager.
      home.sessionVariables = {
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_CACHE_HOME = "$HOME/.local/cache";
        XDG_STATE_HOME = "$HOME/.local/state";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        STACK_XDG = "1";
        GHCUP_USE_XDG_DIRS = "1";
        NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
        LEIN_HOME = "$XDG_DATA_HOME/lein";
        DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
        ANALYZER_STATE_LOCATION_OVERRIDE = "$XDG_CONFIG_HOME/dartServer";
        EDITOR = "nvim";
        SCRIPTS = "$HOME/.local/scripts";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
        NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
        LESSHISTFILE = "-";
        JUPYTER_PLATFORM_DIRS = "1";
        PATH = "$HOME/.local/bin:$PATH:/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin";
      };
      programs.zsh.enable = true;
      programs.zsh.dotDir = ".config/zsh";
      programs.zsh.initExtra = ''
        . $CARGO_HOME/env
        source $HOME/.orbstack/shell/init.zsh 2>/dev/null || :
        eval $(/opt/homebrew/bin/brew shellenv)
        eval $(orbctl completion zsh)
        fpath+=("$(brew --prefix)/share/zsh/site-functions")
        prompt pure
        zstyle :prompt:pure:path color cyan
      '';
      programs.zsh.shellAliases = {
        ls = "lsd -a --color=auto";
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        wget = "wget --hsts-file=$XDG_CACHE_HOME/wget-hsts";
        gpg = "gpg --homedir $XDG_DATA_HOME/gnupg";
        dr = "darwin-rebuild switch --flake ~s/nix-config/";
      };
      programs.zsh.history = {
        path = "$XDG_STATE_HOME/zsh/history";
      };
      programs.zsh.dirHashes = {
        n = "$HOME/Documents/notes";
        c = "$HOME/.config";
        s = "$HOME/source";
        D = "$HOME/Downloads";
        d = "$HOME/Documents";
        ua = "$HOME/Applications";
        a = "/Applications";
        h = "$HOME/OrbStack/arch/home/patrick";
        e = "$HOME/source/exercism";
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
}
