{ config, pkgs, ... }:

{
  boot = {
    # extraModulePackages = with pkgs.linuxPackages; [ sysdig ];
  };

  environment.systemPackages = with pkgs; [
    bind # provides `dig`
    cryptsetup
    dmidecode
    dstat
    file
    git
    gptfdisk
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
    # sysdig
    tcpdump
    tmux
    tree
    unzip
    wget
    which
    wireshark
  ];
}
