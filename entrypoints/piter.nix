{ config, pkgs, ... }:

{ imports = [
    ./audio.nix
    ./base.nix
    ./compton.nix
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
    ./sysadmin.nix
    ./utility-scripts.nix
    ./virtualization.nix
    ./x.nix
  ];

  networking = {
    hostName = "piter";
    hostId = "1f372e1b";
  };
}
