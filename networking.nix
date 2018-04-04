{ config, pkgs, ... }:

{ hardware.bluetooth.enable = true;

  networking = {
    extraHosts = ''
      104.156.231.205 thufir
    '';

    dhcpcd.extraConfig = ''
      nohook resolv.conf
      noipv4ll
    '';
    enableIPv6 = false; # openvpn rules would need to be expanded
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    wireless.enable = true;  # I directly use wpa_supplicant and dhcpcd
  };

  services.dnsmasq.enable = true;
}
