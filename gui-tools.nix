{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    arandr
    chromium
    clementine
    dmenu
    ghostscriptX
    glxinfo
    i3lock
    i3status
    imagemagick
    jmtpfs
    kde5.quasselClient
    libnotify
    lmms
    pass
    pavucontrol
    pianobar
    qjackctl
    rosegarden
    rxvt_unicode_with-plugins
    samba # provides ntlm_auth, which wine stuff needs
    steam
    # supercollider
    vlc
    wineStaging
    xdotool
    xlibs.xev
    xsane
    xsel
    youtube-dl
    zathura
  ];
}
