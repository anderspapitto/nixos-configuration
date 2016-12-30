{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    arandr
    aria2
    # calibre
    chromium
    clerk
    clipit
    dmenu
    firefox
    ghostscriptX
    glxinfo
    i3lock
    i3status
    imagemagick
    jmtpfs
    quasselClient
    libnotify
    mcomix
    ncmpcpp
    pass
    pavucontrol
    pianobar
    rofi
    rofi-pass
    rxvt_unicode_with-plugins
    samba # providse ntlm_auth, which wine stuff needs
    spotify
    vlc
    wineStaging
    xdotool
    xlibs.xev
#    xsane
    xsel
    youtube-dl
    zathura
  ];
}
