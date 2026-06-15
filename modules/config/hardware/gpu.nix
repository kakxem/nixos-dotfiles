{
  lib,
  pkgs,
  gpu,
  ...
}:

let
  isNvidia = builtins.elem gpu [
    "nvidia"
    "nvidia-open"
  ];
in
{
  hardware.graphics = {
    enable = gpu != "none";
    enable32Bit = gpu != "none";
    extraPackages = lib.optionals (gpu == "intel") [
      pkgs.intel-media-driver
      pkgs.vpl-gpu-rt
    ];
  };

  hardware.amdgpu.initrd.enable = gpu == "amd";

  services.xserver.videoDrivers =
    if isNvidia then
      [ "nvidia" ]
    else if gpu == "intel" then
      [ "modesetting" ]
    else
      [ ];

  hardware.nvidia = lib.mkIf isNvidia {
    modesetting.enable = true;
    open = gpu == "nvidia-open";
    nvidiaSettings = true;
  };
}
