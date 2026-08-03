#
# Sunshine
#

{ ... }:

{
  services.sunshine = {
    enable = true;
    # Disable the system-wide user unit because it also starts in GDM's greeter
    # session and claims Sunshine's ports. Start Sunshine manually instead.
    # https://github.com/nixos/nixpkgs/issues/513458
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };
}
