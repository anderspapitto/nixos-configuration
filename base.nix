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
      promptInit = ''
        PS1="\[\033[1;32m\][\u@\h:\w]\n\$\[\033[0m\] "
      '';
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
