{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    arandr
#    audacious
    chromium
    clementine
    dmenu
    ghostscriptX
    gimp
    glxinfo
    i3lock
    i3status
    imagemagick
    jmtpfs # for mtp file transfer to android
    libnotify
    pass
    pavucontrol
    pianobar
    qjackctl
    kde4.quasselClientWithoutKDE
#    kf513Packages.quasselClient
    rxvt_unicode_with-plugins
    samba # provides ntlm_auth, which wine stuff needs
    steam
    supercollider
    vlc
    wineStaging
#    winetricks
    xdotool
    xlibs.xev
    xsane
    xsel
    youtube-dl
    zathura
  ];
}
