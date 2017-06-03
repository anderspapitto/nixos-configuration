{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    arandr
    chromium
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
    mcomix
    ncmpcpp
    pass
    pavucontrol
    pianobar
    rofi
    rxvt_unicode_with-plugins
    samba # providse ntlm_auth, which wine stuff needs
    spotify
    (steam.override { nativeOnly = true; newStdcpp = true; }).run
    tuxguitar
    unrar # needed by mcomix for .cbr
    vlc
    (wine.override { wineRelease = "staging"; wineBuild = "wineWow"; })
    xdotool
    xlibs.xev
#    xsane
    xsel
    youtube-dl
  ];
}
