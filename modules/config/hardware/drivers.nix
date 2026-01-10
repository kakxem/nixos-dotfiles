{ ... }:

{
  imports = [
    ./generated.nix
  ];

  # Generic hardware settings (Drivers and optimizations)
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
