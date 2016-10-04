{ config, pkgs, pkgs_i686, ... }:

let pulse = pkgs.pulseaudioFull.out;
in {
  environment.systemPackages = with pkgs; [ pulse ];

  services.mpd.enable = true;
}
