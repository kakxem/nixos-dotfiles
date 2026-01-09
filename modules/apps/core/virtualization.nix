{ pkgs, user, ... }:

{
  # Enable dconf (required for virt-manager to save settings)
  programs.dconf.enable = true;

  # Add user to the libvirtd group
  users.users."${user}".extraGroups = [
    "docker"
    "libvirtd"
  ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win # Windows guest drivers
    win-spice # Spice agent for Windows
  ];

  # Manage virtualization settings
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;

    # Docker and waydroid
    docker.enable = true;
    waydroid.enable = true;
  };

  # Services for better guest integration
  services.spice-vdagentd.enable = true;
}
