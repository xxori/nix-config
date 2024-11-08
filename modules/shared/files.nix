{...}: {
  ".config/ghostty/config".text = ''
    font-family = RecMonoLinear Nerd Font Mono
    font-family-bold = RecMonoLinear Nerd Font Mono
    font-family-italic = RecMonoCasual Nerd Font Mono
    font-family-bold-italic = RecMonoCasual Nerd Font Mono
    keybind = global:shift+cmd+ctrl+s=toggle_quick_terminal
    theme = catppuccin-mocha

    shell-integration = zsh
    shell-integration-features = sudo

    font-feature = ss05
    font-feature = -dlig
    font-feature = -liga
    font-thicken = true
    font-feature = -calt
  '';
  ".config/nix/empty-global-registry.json".text = ''{ "version": 2, "flakes": [] }'';
}
