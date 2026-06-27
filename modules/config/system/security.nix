{ pkgs, ... }:

{
  # Security
  security.rtkit.enable = true;
  security.polkit.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  services.pcscd = {
    enable = true;
    plugins = [ pkgs.ccid ];
  };

  environment.systemPackages = with pkgs; [
    opensc
    nssTools
    pcsc-tools
    usbutils
  ];
}
