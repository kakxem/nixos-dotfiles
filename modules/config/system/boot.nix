{ pkgs, ... }:

{
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
}
