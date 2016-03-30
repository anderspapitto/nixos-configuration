{ config, pkgs, ... }:

{  networking.firewall = {
    allowedUDPPorts = [ 21027 ];
    allowedTCPPorts = [ 22000 ];
  };
  services.syncthing = {
    enable = true;
    user = "anders";
    dataDir = "/home/anders/sync";
  };
}
