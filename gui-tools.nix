{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    arandr
    chromium
    dmenu
    ghostscriptX
    glxinfo
    i3lock
    i3status
    imagemagick
    jmtpfs
    kde5.quasselClient
    libnotify
    pass
    pavucontrol
    pianobar
    rxvt_unicode_with-plugins
    vlc
    xdotool
    xlibs.xev
    xsane
    xsel
    youtube-dl
    zathura
  ];
}
