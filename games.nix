{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    crawlTiles
  ];
}
