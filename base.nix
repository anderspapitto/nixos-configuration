{ config, pkgs, ... }:

{ boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.variables = { EDITOR = "emacsclient -c"; };

  networking = {
    firewall = {
      allowPing = true;
    };
  };

  programs = {
    bash = {
      enableCompletion = true;
      interactiveShellInit = ''
        HISTCONTROL=ignoreboth:erasedups
        shopt -s histappend
      '';
      promptInit = ''
        PS1="\[\033[1;32m\][\u@\h:\w]\n\$\[\033[0m\] "
      '';
      shellAliases = { ssh = "TERM=xterm-256color ssh"; };
    };
    ssh.startAgent = false;
    man.enable = true;
  };

  services = {
    openssh.enable = true;
    nixosManual.showManual = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  time.timeZone = "America/Los_Angeles";
}
