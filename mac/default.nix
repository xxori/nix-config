{ inputs, outputs, pkgs, ... }:
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
  nix.extraOptions = ''
    experimental-features = nix-command flakes repl-flake
  '';
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
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
      nixpkgs.overlays = [ outputs.overlays.default ];


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
	nil
	#coq
        android-tools
        gleam
	#erlang
        exercism
        ffmpeg
        coreutils-prefixed
        neovim
        bun
        nodejs
        wget
        gh
        ncdu
        wget
        fzf
        pure-prompt
        lsd
        zsh-autocomplete
        tmux
        texlive.combined.scheme-medium
        typst
        typst-fmt
        zola
        nix-tree
        mktemp # The system mktemp breaks due to invalid flags for MacOS Version
	ripgrep
        uiua
	man-pages
	man-pages-posix
	alejandra
	hyperfine
	pdftk
	curl
	zig
	git

	#idris2
	#opam

	#ruff
        
        (python311.withPackages
          (ps: with ps; [
	  requests
	  pip
	  black
          ]))

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
        ".config/nix/empty-global-registry.json".text = ''{ "version": 2, "flakes": [] }'';
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
        NU_CONFIG_DIR = "${XDG_CONFIG_HOME}/nushell";
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
        PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:/Users/patrick/source/cosmocc-3.3.2/bin:$PATH";
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
        # source "$pkgs.zsh-fzf-tab/share/fzf-tab/fzf-tab.plugin.zsh" 
        source "${pkgs.zsh-f-sy-h}/share/zsh/site-functions/F-Sy-H.plugin.zsh"
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        # Example - exercism download --track=haskell --exercise=space-age
        alias _exercism=${pkgs.exercism}/bin/exercism
        exercism() {
          if [ "$1" = "download" ]; then
            if [ "$(sed s/--track=//g <<< $2)" = "haskell" ]; then
              pname=$(sed s/--exercise=//g <<< $3)
              workdir=$(_exercism workspace)
              if [ ! -d "$workdir/haskell/$pname" ]; then
                _exercism $@ 2>&1 /dev/null || return 1
              fi
              cd $workdir/haskell/$pname
              if [ -f flake.nix ]; then
                echo flake already exists
                return 1
              fi
              sed s/project-name/$pname/g < ../flake.nix.template > flake.nix
              echo "resolver: lts-21.22\nsystem-ghc: true" > stack.yaml
              echo "if ! has nix_direnv_version || ! nix_direnv_version 2.4.0; then\n    source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/2.4.0/direnvrc" "sha256-XQzUAvL6pysIJnRJyR7uVpmUSZfc7LSgWQwq/4mBr1U="\nfi\nuse flake" > .envrc
              direnv allow
              stack setup
              echo success
            fi
          else
            _exercism $@
          fi
        }
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
	norminette = "/usr/bin/python3 -m norminette";
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        wget = "wget --hsts-file=$XDG_CACHE_HOME/wget-hsts";
        gpg = "gpg --homedir $XDG_DATA_HOME/gnupg";
        dr = "darwin-rebuild switch --flake ~s/nix-config/";
        nix-stray-roots = "nix-store --gc --print-roots | egrep -v '^(/nix/var|/run/\w+-system|\{memory)'";
	mm = "/Users/patrick/mini-moulinette/mini-moul.sh";
	francinette = "/Users/patrick/francinette/tester.sh";
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
        nc = "$HOME/source/nix-config";
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

        return config
        --/lua
      '';
      programs.vscode.enable = true;
      programs.vscode.mutableExtensionsDir = true;
      programs.vscode.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        #serayuzgur.crates
        #svelte.svelte-vscode
        ms-python.python
	ms-python.vscode-pylance
        esbenp.prettier-vscode
        christian-kohler.path-intellisense
        jnoortheen.nix-ide
        ms-vscode.live-server
        eamodio.gitlens
        tamasfe.even-better-toml
        #github.vscode-pull-request-github
        # dracula-theme.theme-dracula
        enkia.tokyo-night
        sumneko.lua
        nvarner.typst-lsp
        dart-code.flutter
	dart-code.dart-code
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        haskell.haskell
        justusadam.language-haskell
        uiua-lang.uiua-vscode
        rust-lang.rust-analyzer
	maximedenes.vscoq
	visualstudioexptteam.vscodeintellicode
	gleam.gleam
	ms-vscode.cmake-tools
	bierner.markdown-mermaid
	ms-toolsai.jupyter
	ocamllabs.ocaml-platform
	badochov.ocaml-formatter
	ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
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
        #{
        #  name = "glas-vscode";
        #  publisher = "maurobalbi";
        #  version = "0.2.3";
	#  sha256 = "sha256-h5HCW7KlZZ7Xh26pKOSpN+RCNn/3nhqDgAUMJ5mNQwM=";
        #}
        {
          name = "vscode-thunder-client";
          publisher = "rangav";
          version = "2.19.5";
	  sha256 = "sha256-uBEdiW9tIGo9eYqc2Sf1geMFxVngYhwEg7khH6odwQs=";
        }
	{
	  name = "nand2tetris";
	  publisher = "Throvn";
	  version = "0.0.6";
	  sha256 = "sha256-xQ5O0LomKiM/REFoMlxlRtUlGBI1fz4p8nKxiQRMo0o=";
	}
        #{
        #  name = "erlang-ls";
        #  publisher = "erlang-ls";
        #  version = "0.0.40";
        #  sha256 = "sha256-HFlOig5UUsT+XX0h1dcRQ3mWRsASqvKTMpqqRhVpTAY=";
        #}
        #{
        #  name = "erlang-formatter";
        #  publisher = "sztheory";
        #  version = "1.0.0";
        #  sha256 = "sha256-mvs9DXClvZ9a3X4kagpijhI/B2dPXJNyQMC1mD4GP2c=";
        #}
	#{
	#  name = "qtvsctools";
	#  publisher = "tonka3000";
	#  version = "0.11.0";
	#  sha256 = "sha256-/iJzPI4xJY+Vg9B/ah+zdErq988aXdN/UL1V3fR2nJ8=";
	#}
	  
      ];
      programs.vscode.userSettings = builtins.fromJSON (builtins.readFile ./vscode-settings.json);


      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
}
