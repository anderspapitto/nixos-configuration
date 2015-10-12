{ config, pkgs, ... }:

{ services = {
    xserver = {
      enable = true;
      layout = "us";
      # note typo in base.lst, where it says 'ctrl:ctrl_ralt' when it means 'ctrl:ralt_rctrl'
      xkbOptions = "ctrl:ralt_rctrl, lv3:caps_switch, shift:both_capslock";
      xkbVariant = "colemak";
#      displayManager = {
#        slim.theme = pkgs.stdenv.mkDerivation {
#          name = "nixos-solarized-theme";
#          src = pkgs.fetchurl {
#            url = "https://github.com/anderspapitto/nixos-solarized-slim-theme/archive/1.2.tar.gz";
#            sha256 = "f8918f56e61d4b8f885a4dfbf1285aeac7d7e53a7458e32942a759fedfd95faf";
#          };
#          installPhase = ''cp -R . "$out"'';
#        };
#      };
      windowManager = {
        i3.enable = true;
        default = "i3";
      };
      desktopManager.xterm.enable = false;
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
    };

    redshift = {
      enable = true;
      latitude = "37.7";
      longitude = "133.4";
      temperature.night = 2500;
    };

    unclutter = {
      enable = true;
      arguments = "-idle 4 -grab";
    };

  };

  systemd.user.services = {
    compton = {
      description = "Compton: the lightweight compositing manager";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.compton}/bin/compton -cCG --config /home/anders/config-issue/compton/noninverted-compton.conf";
        Restart = "always";
      };
      wantedBy = [ "default.target" ];
    };

    compton-night = {
      description = "Compton: the lightweight compositing manager";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.compton}/bin/compton -cCG --config /home/anders/config-issue/compton/inverted-compton.conf";
        Restart = "always";
      };
      conflicts = [ "compton.service" ];
    };

    dunst = {
      description = "Lightweight libnotify server";
      environment = {
        DISPLAY = ":0";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = pkgs.writeScript "dunst" ''
          #!${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}
          exec ${pkgs.dunst}/bin/dunst
        '';
        Restart = "always";
      };
      wantedBy = [ "default.target" ];
    };
  };
}
