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
    tree
    which
  ];

  security = {
    setuidPrograms = [ "mtr" "sysdig" "csysdig" "iotop" "iftop" "netstat" "tcpdump" ];
  };
}
