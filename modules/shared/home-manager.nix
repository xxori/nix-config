{pkgs, ...}: {
  zsh = {
    enable = true;
    sessionVariables = rec {
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
      EDITOR = "vim";
      SCRIPTS = "$HOME/.local/scripts";
      WGETRC = "${XDG_CONFIG_HOME}/wgetrc";
      NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
      LESSHISTFILE = "-";
      JUPYTER_PLATFORM_DIRS = "1";
      PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
    };
    dotDir = ".config/zsh";
    initExtra = ''
      #sh
      prompt pure
      zstyle :prompt:pure:path color cyan
      export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
      if [ -n "''${commands[fzf-share]}" ]; then
      source "$(fzf-share)/key-bindings.zsh"
      source "$(fzf-share)/completion.zsh"
      fi
      # source "$pkgs.zsh-fzf-tab/share/fzf-tab/fzf-tab.plugin.zsh"
      source "${pkgs.zsh-f-sy-h}/share/zsh/site-functions/F-Sy-H.plugin.zsh"
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      #/sh
    '';
    shellAliases = {
      gr = "cd $(git rev-parse --show-toplevel)";
      ls = "lsd -a --color=auto";
      wget = "wget --hsts-file=$XDG_CACHE_HOME/wget-hsts";
      nix-stray-roots = "nix-store --gc --print-roots | egrep -v '^(/nix/var|/run/\w+-system|\{memory)'";
    };
    history.path = "$XDG_STATE_HOME/zsh/history";
    dirHashes = {
      n = "$HOME/Documents/notes";
      c = "$HOME/.config";
      s = "$HOME/source";
      D = "$HOME/Downloads";
      d = "$HOME/Documents";
      nc = "$HOME/source/nix-config";
    };
  };
  git = {
    enable = true;
    userEmail = "ori@kek.church";
    userName = "Patrick Thompson";
    signing.key = "7FCAD018C5B82931";
    signing.signByDefault = true;
    lfs.enable = true;
  };
  gh = {
    enable = true;
  };
  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  vscode = {
    enable = true;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions;
      [
        vscodevim.vim
        ziglang.vscode-zig
        #serayuzgur.crates
        #svelte.svelte-vscode
        ms-python.python
        ms-python.vscode-pylance
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        bradlc.vscode-tailwindcss
        gruntfuggly.todo-tree
        christian-kohler.path-intellisense
        jnoortheen.nix-ide
        ms-vscode.live-server
        eamodio.gitlens
        tamasfe.even-better-toml
        #github.vscode-pull-request-github
        # dracula-theme.theme-dracula
        enkia.tokyo-night
        sumneko.lua
        #nvarner.typst-lsp
        dart-code.flutter
        dart-code.dart-code
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        #haskell.haskell
        #justusadam.language-haskell
        uiua-lang.uiua-vscode
        rust-lang.rust-analyzer
        #maximedenes.vscoq
        visualstudioexptteam.vscodeintellicode
        gleam.gleam
        #ms-vscode.cmake-tools
        #bierner.markdown-mermaid
        ms-toolsai.jupyter
        #ocamllabs.ocaml-platform
        #badochov.ocaml-formatter
        charliermarsh.ruff
        ms-vsliveshare.vsliveshare
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
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #{
        #  name = "glas-vscode";
        #  publisher = "maurobalbi";
        #  version = "0.2.3";
        #  sha256 = "sha256-h5HCW7KlZZ7Xh26pKOSpN+RCNn/3nhqDgAUMJ5mNQwM=";
        #}
        {
          name = "wasm-wasi-core";
          publisher = "ms-vscode";
          version = "1.0.2";
          sha256 = "sha256-hrzPNPaG8LPNMJq/0uyOS8jfER1Q0CyFlwR42KmTz8g=";
        }
        {
          name = "vscode-thunder-client";
          publisher = "rangav";
          version = "2.27.6";
          sha256 = "sha256-QZkIV5wW2NT16xPS+r/0qMEhC8YKdXdz1kKflrQ2tYw=";
        }
        {
          name = "super";
          publisher = "LorisCro";
          version = "0.5.3";
          sha256 = "sha256-SSeCNtwiOVk6ZrKvQ8U3eoTEJETVWyymrFOWrXj88Xs=";
        }
        {
          name = "supermd";
          publisher = "LorisCro";
          version = "0.1.0";
          sha256 = "sha256-oIoxxo+IS3TG/Ixv64C+ifTA7QoDur7BUkwifQYIzUE=";
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
      ];
    userSettings = builtins.fromJSON (builtins.readFile ./config/vscode-settings.json) // {"git.path" = "${pkgs.git}/bin/git";};
  };
  home-manager.enable = true;
}
