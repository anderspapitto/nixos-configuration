{ config, pkgs, ... }:

{ nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
    };
  };
}
