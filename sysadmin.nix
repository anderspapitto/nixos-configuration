{ config, pkgs, ... }:

{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ sysdig ];
  };

  environment.systemPackages = with pkgs; [
    bind # provides `dig`
    dmidecode
    dstat
    file
    git
    htop
    iftop
    iotop
    linuxPackages.perf
    lshw
    lsof
    mtr
    nftables
    pciutils
    psmisc
    sysdig
    tcpdump
    tmux
    tree
    unzip
    wget
    which
  ];

  security = {
    setuidPrograms = [ "mtr" "sysdig" "csysdig" "iotop" "iftop" "netstat" "tcpdump" ];
  };
}
