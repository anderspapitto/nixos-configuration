{ config, pkgs, ... }:

{ hardware.bluetooth.enable = false;

  networking = {
    dhcpcd.extraConfig = ''
      nohook resolv.conf
      noipv4ll
    '';
    firewall = {
      allowedUDPPorts = [ 21027 ];
      allowedTCPPorts = [ 22000 ];
    };
    enableIPv6 = false; # openvpn rules would need to be expanded
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    wireless.enable = true;  # I directly use wpa_supplicant and dhcpcd
  };

  services.dnsmasq.enable = true;
}
