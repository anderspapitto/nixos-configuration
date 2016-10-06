{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    arandr
    chromium
    clipit
    dmenu
    ghostscriptX
    glxinfo
    i3lock
    i3status
    imagemagick
    jmtpfs
    quassel
    libnotify
    pass
    pavucontrol
    pianobar
    rofi
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
