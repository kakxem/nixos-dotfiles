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
      extraConfig.pipewire."92-audio-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
        };
      };
    };

    udev.packages = with pkgs; [
      via
    ];

    xserver.excludePackages = [ pkgs.xterm ];
  };
}
