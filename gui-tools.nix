{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    alacritty
    anki
    arandr
    # chromium
    clerk
    clipit
    dmenu
    evince
    firefox
    ghostscriptX
    glxinfo
    haskellPackages.hledger
    haskellPackages.hledger-web
    i3lock
    i3status
    imagemagick
    jmtpfs
    quasselClient
    libnotify
    ncmpcpp
    okular
    pass
    pavucontrol
    pianobar
    rofi
    # rxvt_unicode_with-plugins
    signal-desktop
    spotify
    st
    tdesktop
    tuxguitar
    vlc
    xdotool
    xlibs.xev
#    xsane
    xsel
    youtube-dl
  ];
}
