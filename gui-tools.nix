{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    arandr
    chromium
    clerk
    clipit
    dmenu
    ghostscriptX
    glxinfo
    i3lock
    i3status
    imagemagick
    jmtpfs
    quasselClient
    libnotify
    ncmpcpp
    pass
    pavucontrol
    pianobar
    rofi
    rofi-pass
    rxvt_unicode_with-plugins
    samba # providse ntlm_auth, which wine stuff needs
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
