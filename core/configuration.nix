#
# Core config of nixos
#

{ config, pkgs, lib, user, ... }:

{  
  imports = [
    ./hardware-configuration.nix
    #../modules/desktops/gnome         # GNOME
    ../modules/desktops/hyprland      # HYPRLAND
    #../modules/desktops/kde
    ../modules/apps/core
  ];

  # Nix config
  nix = {
    settings ={
      auto-optimise-store = true;                            # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];    # ** Flakes **
      
      # Hyprland cachix
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
  };

  # Hardware
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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
      package = config.boot.kernelPackages.nvidiaPackages.latest;
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

    flatpak.enable = true;                # Flatpak

    xserver.videoDrivers = ["nvidia"];    # Nvidia drivers
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
     enableSSHSupport = true;
     pinentryFlavor = "curses";
  };
  services.pcscd.enable = true;

  # Enable "UnFree" packages
  nixpkgs.config.allowUnfree = true;
  environment = {
    systemPackages = with pkgs; [
      git
      neovim
      linuxKernel.packages.linux_zen.xone
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
    (nerdfonts.override { fonts = [ 
      "FiraCode" 
      #"CascadiaCode"
     ]; })
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
  system.stateVersion = "23.05"; # Did you read the comment?
}

