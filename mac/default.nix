{ pkgs, rust-overlay, ... }:
{

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  nix.settings = {
    trusted-users = [ "root" "patrick" ];
    allowed-users = [ "@admin" "patrick" ];
    auto-optimise-store = true;
    substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    trusted-substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
  };
  nix.extraOptions = "experimental-features = nix-command flakes repl-flake";
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
      "mactex-no-gui"
      "wineskin"
      "iina"
      "gpg-suite-no-mail"
      "obsidian"
      "steam"
      "calibre"
      "spotify"
      "android-studio"
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
      nixpkgs.overlays = [ rust-overlay.overlays.default ];


      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "23.05"; # Please read the comment before changing.

      # Some of these should probably be system packages...
      home.packages = with pkgs; [
        rnix-lsp
        android-tools
        gleam
        exercism
        ffmpeg
        coreutils-prefixed
        neovim
        bun
        nodejs
        wget
        gh
        hugo
        ncdu
        wget
        fh
        fzf
        pure-prompt
        lsd
        zsh-autocomplete
        tmux
        fd
        mkcert
        texlive.combined.scheme-medium
        typst
        typst-fmt
        zola
        flutter
        cocoapods
        jdk19_headless # Already installed from texlive
        clang-tools_16
        clang_16 # Already installed from wezterm
        nix-tree
        mktemp # The system mktemp breaks due to invalid flags for MacOS Version

        # GUI apps should use brew, but prism needs some wrappers to detect java, etc
        prismlauncher

        (python311.withPackages
          (ps: with ps; [
            pip
            meson
            ninja
          ]))

        rust-bin.stable.latest.default
        rust-analyzer

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
      ];


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
      programs.sioyek.enable = true;
      programs.sioyek.bindings = {
        "zoom_in" = "J";
        "zoom_out" = "K";
      };

      programs.zsh.enable = true;
      programs.zsh.sessionVariables = rec {
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_CACHE_HOME = "$HOME/.local/cache";
        XDG_STATE_HOME = "$HOME/.local/state";
        CARGO_HOME = "${XDG_DATA_HOME}/cargo";
        RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
        STACK_XDG = "1";
        GHCUP_USE_XDG_DIRS = "1";
        NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
        LEIN_HOME = "${XDG_DATA_HOME}/lein";
        DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
        ANALYZER_STATE_LOCATION_OVERRIDE = "${XDG_CONFIG_HOME}/dartServer";
        EDITOR = "nvim";
        SCRIPTS = "$HOME/.local/scripts";
        WGETRC = "${XDG_CONFIG_HOME}/wgetrc";
        NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
        LESSHISTFILE = "-";
        JUPYTER_PLATFORM_DIRS = "1";
        PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
      };
      programs.zsh.dotDir = ".config/zsh";
      programs.zsh.initExtra = ''
        #sh
        source $HOME/.orbstack/shell/init.zsh 2>/dev/null || :
        eval $(/opt/homebrew/bin/brew shellenv)
        eval $(orbctl completion zsh)
        fpath+=("$(brew --prefix)/share/zsh/site-functions")
        prompt pure
        zstyle :prompt:pure:path color cyan
        export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
        if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
        fi 
        source "$SCRIPTS/iterm2_shell_integration.zsh"
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh" 
        source "${pkgs.zsh-f-sy-h}/share/zsh/site-functions/F-Sy-H.plugin.zsh"
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh 
        # function code() {
        #   if [ -f $1/flake.nix ]; then
        #     nix develop path://$(readlink -f $1) -c code $1
        #   else
        #     code -e $1
        #   fi
        # } 
        #/sh
      '';
      # ^ This will pull the zsh plugins automatically. Alternatively, we could use zsh.antidote

      programs.zsh.shellAliases = {
        gr = "cd $(git rev-parse --show-toplevel)";
        ls = "lsd -a --color=auto";
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        wget = "wget --hsts-file=$XDG_CACHE_HOME/wget-hsts";
        gpg = "gpg --homedir $XDG_DATA_HOME/gnupg";
        dr = "darwin-rebuild switch --flake ~s/nix-config/";
        nix-stray-roots = "nix-store --gc --print-roots | egrep -v '^(/nix/var|/run/\w+-system|\{memory)'";

      };
      programs.zsh.history.path = "$XDG_STATE_HOME/zsh/history";

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

      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;


      programs.wezterm.enable = true;
      programs.wezterm.extraConfig = ''
        --lua
        local wezterm = require 'wezterm'

        local config = {}

        if wezterm.config_builder then
        config = wezterm.config_builder()
        end

        config.font = wezterm.font("BerkeleyMono Nerd Font")
        config.font_size = 12.0
        -- config.color_scheme = "synthwave"
        config.color_scheme = "Tokyo Night"
        config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
        config.integrated_title_button_style = "MacOsNative"
        config.window_background_opacity = 0.9


        return config
        --/lua
      '';
      programs.vscode.enable = true;
      programs.vscode.mutableExtensionsDir = false;
      programs.vscode.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        serayuzgur.crates
        svelte.svelte-vscode
        ms-python.python
        ms-python.vscode-pylance
        esbenp.prettier-vscode
        christian-kohler.path-intellisense
        jnoortheen.nix-ide
        ms-vscode.live-server
        gleam.gleam
        eamodio.gitlens
        github.copilot
        github.copilot-chat
        tamasfe.even-better-toml
        ms-python.black-formatter
        github.vscode-pull-request-github
        # dracula-theme.theme-dracula
        enkia.tokyo-night
        sumneko.lua
        nvarner.typst-lsp
        dart-code.flutter
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv

        rust-lang.rust-analyzer
        (pkgs.vscode-utils.buildVscodeExtension {
          name = "xxori-nix-embedded-langs-0.0.1";
          version = "0.0.1";
          src = builtins.fetchurl {
            url = "https://github.com/xxori/nix-embedded-langs-vscode/releases/download/v0.0.1/nix-embedded-langs-0.0.1.vsix";
            sha256 = "cddc72771b7816ad3f4b8ec8f3278748a0b52825dc4e5ec6e9b0bc0d58100c67";
            # A vsix file is just a zip, but we dont know how to extract it, so we rename it to .zip
            name = "xxori-nix-embedded-langs.zip";
          };
          vscodeExtPublisher = "xxori";
          vscodeExtName = "nix-embedded-langs";
          vscodeExtUniqueId = "xxori.nix-embedded-langs";
        })
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vsliveshare";
          publisher = "ms-vsliveshare";
          version = "1.0.5892";
          sha256 = "e/cJONR/4Lai18h7kHJU8UEn5yrUZHPoITAyZpLenTA=";
        }
        {
          name = "prettier-sql-vscode";
          publisher = "inferrinizzard";
          version = "1.6.0";
          sha256 = "l6pf/+uv8Bn4uDMX0CbzSjydTStr73uRY550Ad9wm7Q=";
        }
        {
          name = "vscodeintellicode";
          publisher = "VisualStudioExptTeam";
          version = "1.2.30";
          sha256 = "f2Gn+W0QHN8jD5aCG+P93Y+JDr/vs2ldGL7uQwBK4lE=";
        }
        {
          name = "vscode-thunder-client";
          publisher = "rangav";
          version = "2.15.3";
          sha256 = "pn/wzehVQPk0Jck+1QFz508+5t8ToZiZ/UUiGwlB05M=";
        }
      ];
      programs.vscode.userSettings = builtins.fromJSON (builtins.readFile ./vscode-settings.json);


      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
}
