{ config, pkgs, ... }:

{ boot.loader = {
    gummiboot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
