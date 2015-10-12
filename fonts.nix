{ config, pkgs, ... }:

{ i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "colemak/en-latin9";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      unifont
      ubuntu_font_family
      noto-fonts
      symbola
    ];
  };
}
