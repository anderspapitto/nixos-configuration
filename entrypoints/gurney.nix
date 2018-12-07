{ config, pkgs, ... }:

{ imports = [
    ./audio.nix
    ./android.nix
    ./base.nix
    ./dev-tools.nix
    ./emacs.nix
    ./fonts.nix
    ./games.nix
    ./gui-tools.nix
    ./hardware-configuration.nix
    ./inl-tools.nix
    ./laptop-base.nix
    ./networking.nix
    ./nix.nix
    ./nixpkgs.nix
    ./printing.nix
    ./redis.nix
    ./syncthing.nix
    ./sysadmin.nix
    ./uefi.nix
    ./utility-scripts.nix
    ./virtualization.nix
    ./x.nix

    ./private/default.nix
  ];

  networking = {
    hostName = "gurney";
    hostId = "d9ebdbe0";

    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.2/24" ];
        privateKeyFile = "/root/wireguard-keys/private";
        peers = [
          { publicKey = "ghK62ZFGd9zkRPfF6JehK7OMAW6HMdy68RNalq9FVUo=";
            # allowedIPs = [ "10.100.0.1" ];
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "thufir:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/27cadee9-bc6c-4e62-9494-fa2f789bf98b";
      preLVM = true;
      allowDiscards = true;
    }
  ];
}
