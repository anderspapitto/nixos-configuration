{ config, pkgs, ... }:

{ imports = [
    ./audio.nix
    ./base.nix
    ./dev-tools.nix
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
    hostId = "1f372e1b";
  };
}
