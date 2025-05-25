#
# Core config of nixos
#

{ config, pkgs, lib, user, ... }:

{  
  imports = [
    ./hardware-configuration.nix
    ../modules/desktops/gnome         # GNOME
    # ../modules/desktops/hyprland      # HYPRLAND
    # ../modules/desktops/kde             # KDE
    ../modules/apps/core
  ];

  # Nix config
  nix = {
    settings ={
      auto-optimise-store = true;                            # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];    # ** Flakes **
    };
    gc = {                                  # Automatic garbage collection
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
        configurationLimit = 5;                 # Limit the amount of configurations
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;                              # Grub auto select time
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  # Hardware
  hardware = {    
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva
      ];
    };

    nvidia = {
      # Modesetting is needed for most wayland compositors
      modesetting.enable = true;
      powerManagement.enable = true;

      # Use the open source version of the kernel module
      open = false;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    xone.enable = true;
  };

  # Services
  services = {
    printing.enable = true;               # Printing

    pipewire = {                          # Pipewire
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      audio.enable = true;
    };

    xserver.videoDrivers = ["nvidia"];    # Nvidia drivers

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
    extraGroups = [ "networkmanager" "wheel" "docker"];
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

  # Enable "UnFree" packages
  nixpkgs.config.allowUnfree = true;
  environment = {
    systemPackages = with pkgs; [
      git
      neovim
      linuxKernel.packages.linux_zen.xone
      xclip
      via
      xdg-utils
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";             # Enable wayland for electron
      
      # Enable VA-API with nvidia for Firefox
      MOZ_X11_EGL = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      EGL_PLATFORM = "wayland";
      LIBVA_DRIVER_NAME = "nvidia";
      LIBVA_MESSAGING_LEVEL = "1";
    };

  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
  ];

  # Remove xterm
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Docker
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

