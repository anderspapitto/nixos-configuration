{ config, pkgs, ... }:

{ boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = with pkgs; [
    tmux
    unzip
    wget
  ];

  networking = {
    firewall = {
      allowPing = true;
    };
  };

  programs = {
    bash = {
      enableCompletion = true;
      shellAliases = { ssh = "TERM=xterm-256color ssh"; };
    };
    ssh.startAgent = false;
    man.enable = true;
  };

  services = {
    sshd.enable = true;
    nixosManual.showManual = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  time.timeZone = "America/Los_Angeles";
}
