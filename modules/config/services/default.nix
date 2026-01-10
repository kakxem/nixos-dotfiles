{ pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./scripts.nix
  ];

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

    xserver.excludePackages = [ pkgs.xterm ];
  };
}
