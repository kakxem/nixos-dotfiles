#
# Core config of nixos
#

{
  pkgs,
  user,
  desktop ? "gnome",
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/desktops
    ../modules/apps/core
  ];

  # Nix config
  nix = {
    settings = {
      auto-optimise-store = true; # Optimise syslinks
      experimental-features = [
        "nix-command"
        "flakes"
      ]; # ** Flakes **
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Limit the amount of configurations
      };
      efi.canTouchEfiVariables = true;
      timeout = 1; # Grub auto select time
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  # Hardware
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.initrd.enable = true;
  };

  # Services
  services = {
    printing.enable = true; # Printing

    pipewire = {
      # Pipewire
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      audio.enable = true;
    };

    udev.packages = with pkgs; [
      via
    ];
  };

  # Configure console keymap (tty)
  # console.keyMap = "dvorak";

  # Time zone & internationalisation
  time.timeZone = "Europe/Madrid";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_ES.UTF-8";
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
      LC_TIME = "es_ES.UTF-8";
    };
  };

  # Enable fish (I'll be used for root user)
  programs.fish.enable = true;

  # User configs
  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # Security
  security.rtkit.enable = true;
  #security.polkit.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  services.pcscd.enable = true;

  environment = {
    systemPackages = with pkgs; [
      git
      neovim
      linuxKernel.packages.linux_zen.xone
      xclip

      # Expose custom setup scripts as system-wide commands
      (pkgs.writeShellScriptBin "rebuild-desktop" ''
        set -euo pipefail

        # Always rebuild from your live checkout
        FLAKE_PATH="$HOME/.config/nixos-dotfiles"
        DESKTOP="''${DESKTOP:-gnome}"

        # If not running as root, re-exec via sudo.
        # We don't interpolate FLAKE_PATH via Nix, so it won't be frozen in the store.
        if [ "$EUID" -ne 0 ]; then
          exec sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "$FLAKE_PATH#desktop" --argstr desktop "$DESKTOP"
        else
          exec ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "$FLAKE_PATH#desktop" --argstr desktop "$DESKTOP"
        fi
      '')

      (pkgs.writeShellScriptBin "rebuild-home" ''
        set -euo pipefail

        if [ "$EUID" -eq 0 ]; then
          echo "rebuild-home: this script should be run as your regular user, not as root." >&2
          exit 1
        fi

        FLAKE_PATH="$HOME/.config/nixos-dotfiles"
        DESKTOP="''${DESKTOP:-gnome}"
        exec ${pkgs.home-manager}/bin/home-manager switch --flake "$FLAKE_PATH#kakxem" --argstr desktop "$DESKTOP"
      '')
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Enable wayland for electron

      # Enable VA-API for Firefox
      MOZ_DISABLE_RDD_SANDBOX = "1";
      EGL_PLATFORM = "wayland";
      LIBVA_MESSAGING_LEVEL = "1";
    };

  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    noto-fonts-cjk-sans
  ];

  # Remove xterm
  services.xserver.excludePackages = [ pkgs.xterm ];

  # # Changes needed for waydroid
  networking.nftables.enable = true;

  # Desktop option (passed from flake)
  desktop = desktop;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
