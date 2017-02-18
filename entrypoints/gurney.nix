{ config, pkgs, ... }:

{ imports = [
    ./audio.nix
    ./android.nix
    ./base.nix
    ./compton.nix
    ./dev-tools.nix
    ./dropbox.nix
    ./emacs.nix
    ./fonts.nix
    ./gui-tools.nix
    ./hardware-configuration.nix
    ./inl-tools.nix
    ./laptop-base.nix
    ./networking.nix
    ./nix.nix
    ./nixpkgs.nix
    ./printing.nix
    ./redis.nix
    ./rulemak.nix
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
