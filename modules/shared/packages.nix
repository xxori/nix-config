{pkgs, ...}:
with pkgs; [
  nil
  #coq
  android-tools
  gleam
  erlang_27
  rebar3
  exercism
  ffmpeg
  coreutils-prefixed
  neovim
  bun
  nodejs
  pnpm
  wget
  ncdu
  wget
  fzf
  pure-prompt
  lsd
  zsh-autocomplete
  tmux
  texlive.combined.scheme-full
  typst
  typst-fmt
  nix-tree
  mktemp # The system mktemp breaks due to invalid flags for MacOS Version
  ripgrep
  uiua
  man-pages
  man-pages-posix
  alejandra
  hyperfine
  curl
  zig

  atkinson-hyperlegible
  (pkgs.nerdfonts.override {fonts = ["Recursive"];})
  berkeley

  #idris2
  #opam

  #ruff

  (python312.withPackages
    (ps:
      with ps; [
        pip
        poetry-core
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
]
