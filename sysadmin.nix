{ config, pkgs, ... }:

{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ sysdig ];
  };

  environment.systemPackages = with pkgs; [
    bind # provides `dig`
    cryptsetup
    dmidecode
    dstat
    file
    git
    gptfdisk
    gnupg20 # emacs wants the gpg2 binary?
    htop
    iftop
    iotop
    # linuxPackages.perf
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
    wireshark
  ];
}
