{ config, pkgs, ... }:

let gurney-pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt6axfh25SwAPkrTQlIJKqZkQ2zxxI6/a45Oa2uGclh2qjpic4egy4zQbHXCJOM8Baz9xfzmJDxWAhwckiiXYvG6W5bignIfx8F/z8P27Jganv9Np5GptG2E0tZKoSFXkCN7B3H4+/r4O6eWsx9mM8NzABIP6i+vqZ/5gaW1PUGBWX4yZRVKr9WbTGJp4R6txvW6aPaJKGOGqFCDqU9SzWC8uZFWOxcIMI/2gn0eW27cCL/ro1i4DDVMQsDnDqxJ6cHIKzNsQcGSGN8q67zPMFdxlrZ+9xnATkQxyRXuuU5xArusY+acWGUBa3lixfYTD9XFcgddctG3x6xwSHN9zx anders@gurney";
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./base.nix
      ./sysadmin.nix
      ./nix.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/vda";
    };
  };

  networking = {
    hostName = "thufir";
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o enp0s3 -j MASQUERADE
      '';
      extraStopCommands = ''
        iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o enp0s3 -j MASQUERADE
      '';
      allowedUDPPorts = [ 1194 1195 ]; # openvpn
      allowedTCPPorts = [ 4242 ]; # quassel
      trustedInterfaces = [ "tun0" "tun1" ];
    };
  };

  services = {
    fail2ban = {
      enable = true;
    };
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
    gitolite = {
      enable = true;
      adminPubkey = gurney-pubkey;
      dataDir = "/var/lib/gitolite/gitolite";
    };
    openvpn = {
      servers = {
        for-laptop = {
          config = ''
            dev tun0
            ifconfig 10.8.0.1 10.8.0.2
            secret /root/static.key
            port 1194
            comp-lzo
          '';
        };
        for-phone = {
          config = ''
            dev tun1
            ifconfig 10.8.0.1 10.8.0.3
            secret /root/phone-static.key
            port 1195
            comp-lzo
          '';
        };
      };
    };
    quassel = {
      enable = true;
      interfaces = [ "0.0.0.0" ];
    };
    syncthing = {
      enable = true;
      useInotify = true;
      openDefaultPorts = true;
    };
  };
}
