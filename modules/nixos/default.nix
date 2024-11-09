{
	inputs,
  outputs,
  pkgs,
  lib,
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
      desktopManager.xfce.enable = true;
      displayManager.lightdm = {
        enable = true;
        greeters.slick.enable = true;
      };
      xkb = {
        layout = "us";
      };
    };
    displayManager.defaultSession = "xfce";
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
    powerManagement.enable = false;
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
    extraGroups = ["wheel" "docker"];
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
    home.packages =
      (import ../shared/packages.nix {inherit pkgs;})
      ++ (with pkgs; [
        vim
        firefox
	#inputs.ghostty.packages.x86_64-linux.default
      ]);
    home.file = import ../shared/files.nix {};
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [outputs.overlays.default];
    programs =
      sharedProgs
      // {
        gpg.enable = true;
        git = sharedProgs.git // {
          signing.key = "5582C6450991F8B1";
        };
        zsh =
          sharedProgs.zsh
          // {
            shellAliases = sharedProgs.zsh.shellAliases // {dr = "sudo nixos-rebuild switch --flake /home/patrick/source/nix-config";};
          };
      };
  };
}
