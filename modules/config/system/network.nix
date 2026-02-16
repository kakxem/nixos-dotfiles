{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 11434 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
}
