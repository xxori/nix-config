{
  inputs,
  outputs,
  pkgs,
  ...
}: let
  user = "patrick";
  keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGYUxQeYxlRmrvlIAYoKowqZc0qSEcL2PqDrWvPTEP0"];
  sharedProgs = import ../shared/home-manager.nix {inherit pkgs;};
in {
  imports = [
    ../shared
    ./hardware-configuration.nix
  ];
  system.stateVersion = "24.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Australia/Adelaide";

  networking = {
    hostName = "patrick-pc";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
  };

  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  programs = {
    gnupg.agent.enable = true;
    dconf.enable = true;
    zsh.enable = true;
    river.enable = true;
  };

  services = {
    printing.enable = true;
    tailscale.enable = true;
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
    };
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      # displayManager.lightdm = {
      #   enable = true;
      #   greeters.slick.enable = true;
      # };
      desktopManager.xfce.enable = true;
      xkb = {
        layout = "us";
      };
    };
    displayManager.defaultSession = "xfce";
    displayManager.ly.enable = true;
    displayManager.ly.settings = {
      animation = "matrix";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
  
  hardware.pulseaudio.enable = false;
  hardware.graphics.enable = true;
  security.rtkit.enable = true;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  virtualisation.docker = {
    enable = true;
    logDriver = "json-file";
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "video" "render"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = keys;
  };
  home-manager.users.${user} = {
    config,
    pkgs,
    ...
  }: {
    home.username = "${user}";
    home.homeDirectory = "/home/${user}";
    home.stateVersion = "23.05";
    services = {
      mako = {
        enable = true;
        defaultTimeout = 3000;
      };
      swayidle = {
        enable = true;
        systemdTarget = "river-session.target";
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -fF -i ~/wallpaper.jpg";
          }
        ];
        timeouts = [
          {
            timeout = 60;
            command = "${pkgs.swaylock}/bin/swaylock -fF -i ~/wallpaper.jpg";
          }
          {
            timeout = 180;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };
    home.packages =
      (import ../shared/packages.nix {inherit pkgs;})
      ++ (with pkgs; [
        vim
        firefox
        spotify
        inputs.ghostty.packages.x86_64-linux.default
        (pkgs.discord.override {withOpenASAR = true;})
        killall
        swaybg
        arc-theme
        epapirus-icon-theme
        slstatus
        wmenu
        dam
        swaylock
        swayidle
      ]);
    home.file = import ../shared/files.nix {};
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [outputs.overlays.default];
    wayland.windowManager.river = {
      enable = true;
      xwayland.enable = true;
      extraSessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
      };
      extraConfig = ''
        killall dam
        killall swaybg
        killall rivertile
        riverctl spawn "swaybg -i ~/wallpaper.jpg"
        riverctl spawn "slstatus -s | dam"
        riverctl spawn rivertile
        riverctl default-layout rivertile
        riverctl send-layout-cmd rivertile "main-location left"
        for i in $(seq 1 9)
        do
            tagmask=$((1 << ($i - 1)))
            riverctl map normal Mod4               $i set-focused-tags    $tagmask
            riverctl map normal Mod4+Shift         $i set-view-tags       $tagmask
            riverctl map normal Mod4+Control       $i toggle-focused-tags $tagmask
            riverctl map normal Mod4+Shift+Control $i toggle-view-tags    $tagmask
        done
        all_tags_mask=$(((1 << 32) - 1))
        riverctl map normal Mod4       0 set-focused-tags $all_tags_mask
        riverctl map normal Mod4+Shift 0 set-view-tags    $all_tags_mask
      '';
      settings = {
        map = {
          normal = {
            "Mod4 E" = "exit";
            "Mod4 F" = "spawn firefox";
            "Mod4 Q" = "close";
            "Mod4 T" = "spawn foot";
            "Mod4 J" = "focus-view previous";
            "Mod4 K" = "focus-view next";
            "Mod4+Shift J" = "swap previous";
            "Mod4+Shift K" = "swap next";
            "Mod4 Return" = "zoom";
            "Mod4+Shift H" = "send-layout-cmd rivertile \"main-count +1\"";
            "Mod4+Shift L" = "send-layout-cmd rivertile \"main-count -1\"";
            "Mod4+Shift Space" = "toggle-float";
            "Mod4 D" = "spawn wmenu-run";
            "Mod4 L" = "spawn \"swaylock -fF -i ~/wallpaper.jpg\"";
          };
        };
      };
    };
    programs =
      sharedProgs
      // {
        gpg.enable = true;
        git =
          sharedProgs.git
          // {
            signing.key = "5582C6450991F8B1";
            signing.signByDefault = true;
          };
        foot = {
          enable = true;
          settings = {
            main = {
              font = "RecMonoLinear Nerd Font Mono:size=12";
              font-bold = "RecMonoLinear Nerd Font Mono:size=12";
              font-italic = "RecMonoCasual Nerd Font Mono:size=12";
              font-bold-italic = "RecMonoCasual Nerd Font Mono:size=12";
              dpi-aware = "yes";
              term = "xterm-256color";
            };
            cursor.color = "11111b f5e0dc";
            colors = {
              background = "1e1e2e";
              foreground = "cdd6f4";
              regular0 = "45475a";
              regular1 = "f38ba8";
              regular2 = "a6e3a1";
              regular3 = "f9e2af";
              regular4 = "89b4fa";
              regular5 = "f5c2e7";
              regular6 = "94e2d5";
              regular7 = "bac2de";
              bright0 = "585b70";
              bright1 = "f38ba8";
              bright2 = "a6e3a1";
              bright3 = "f9e2af";
              bright4 = "89b4fa";
              bright5 = "f5c2e7";
              bright6 = "94e2d5";
              bright7 = "a6adc8";
              # "16"="fab387";
              # "17"="f5e0dc";
              selection-foreground = "cdd6f4";
              selection-background = "414356";
              search-box-no-match = "11111b f38ba8";
              search-box-match = "cdd6f4 313244";
              jump-labels = "11111b fab387";
              urls = "89b4fa";
            };
          };
        };
        zsh =
          sharedProgs.zsh
          // {
            shellAliases = sharedProgs.zsh.shellAliases // {dr = "sudo nixos-rebuild switch --flake /home/patrick/source/nix-config";};
          };
      };
  };
}
