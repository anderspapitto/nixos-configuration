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

  environment.systemPackages = with pkgs; [ wireguard ];

  networking = {
    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/root/wireguard-keys/private";
        peers = [
          { publicKey = "qFE4Q7ieGRqUyEr2MDAd6rRhZkrJD3M3/dqSwwo+VTc=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
        ];
      };
    };
    hostName = "thufir";
    enableIPv6 = false;
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE
      '';
      extraStopCommands = ''
        iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE
      '';
      allowedUDPPortRanges = [
        { from =  1194; to =  1195; } # openvpn
        { from = 60000; to = 61000; } # mosh
      ];
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
        laptop = {
          config = ''
            ifconfig 10.8.0.1 10.8.0.2
            dev tun0
            port 1194
            secret /root/static.key
          '';
        };
        phone = {
          config = ''
            ifconfig 10.8.0.1 10.8.0.3
            dev tun1
            port 1195
            secret /root/static.key
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
      openDefaultPorts = true;
    };
  };
}
