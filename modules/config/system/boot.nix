{ pkgs, ... }:

{
  # Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Limit the amount of configurations
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = 0; # Hide bootloader menu
    };
    kernelPackages = pkgs.linuxPackages_zen;

    # Plymouth
    # Disabled because on high-end hardware (NVMe, last-gen GPU/CPU) the boot is too fast for Plymouth to be useful
    plymouth.enable = false;

    # Silent Boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"
      "fbcon=nodefer"
    ];
  };

  # Enable early KMS for AMDGPU
  hardware.amdgpu.initrd.enable = true;
}
