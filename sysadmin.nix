{ config, pkgs, ... }:

{
  boot = {
    # extraModulePackages = with config.boot.kernelPackages; [ sysdig ];
  };

  environment.systemPackages = with pkgs; [
    bind # provides `dig`
    binutils
    cryptsetup
    dmidecode
    dstat
    file
    git
    gptfdisk
    gnupg # emacs wants the gpg2 binary?
    htop
    iftop
    iotop
    linuxPackages.perf
    lshw
    lsof
    mosh
    mtr
    neovim
    neovim-remote
    neovim-qt
    nftables
    numactl
    openssl
    pciutils
    psmisc
    ripgrep
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
