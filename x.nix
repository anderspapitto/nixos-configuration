{ config, pkgs, ... }:

let dunstrc = builtins.toFile "dunstrc" (pkgs.lib.readFile ./config/dunstrc);
    background-image = pkgs.fetchurl {
      url = "http://orig01.deviantart.net/1810/f/2012/116/a/4/tranquility_by_andreewallin-d4xjtd0.jpg";
      sha256 = "17jcvy268aqcix7hb8acn9m9x7dh8ymb07w4f7s9apcklimz63bq";
    };
    solarized-theme = pkgs.stdenv.mkDerivation {
      name = "nixos-solarized-theme";
      src = pkgs.fetchFromGitHub {
        owner = "anderspapitto";
        repo = "nixos-solarized-slim-theme";
        rev = "2822b7cb7074cf9aa36afa9b5cabd54105b3306c";
        sha256 = "0jp7qq02ly9wiqbgh5yamwd31ah1bbybida7mn1g6qpdijajf247";
      };
      installPhase = ''cp -R . "$out"'';
    };
in {
  environment.etc = {
    "i3/config".source = ./config/i3;
    "i3/status".source = ./config/i3status;
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      # note typo in base.lst, where it says 'ctrl:ctrl_ralt' when it
      # means 'ctrl:ralt_rctrl'
      xkbOptions = "ctrl:ralt_rctrl, lv3:caps_switch, shift:both_capslock";
      xkbVariant = "colemak";
      displayManager.slim.theme = solarized-theme;
      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
          extraSessionCommands = ''
            ${pkgs.gnupg}/bin/gpg-connect-agent /bye
            export GPG_TTY=$(tty)
            xrdb ${builtins.toFile "Xresources" (builtins.readFile ./config/xresources)}

            # bit of a hack. I don't want to have it pulled in by
            # display-manager, or it will get restarted everytime if
            # i'm toggled to dark mode
            systemctl start compton

            # these two are obviously hacks
            ${pkgs.clipit}/bin/clipit &
            systemctl start openvpn-thufir &
          '';
          configFile = "/etc/i3/config";
        };
        default = "i3";
      };
      desktopManager.xterm.enable = false;
      synaptics = {
        enable = true;
        tapButtons = false;
        twoFingerScroll = true;
      };
    };
  };

  systemd.services = {
    redshift = {
      description = "Redshift colour temperature adjuster";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = "${pkgs.redshift}/bin/redshift -l 37.7:133.4 -t 5500:2500 -b 1:1";
        RestartSec = 3;
        Restart = "always";
      };
      wantedBy = [ "display-manager.service" ];
      after = [ "display-manager.service" ];
    };

    xbanish = {
      description = "xbanish hides the mouse pointer";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = "${pkgs.xbanish}/bin/xbanish";
        RestartSec = 3;
        Restart = "always";
      };
      wantedBy = [ "graphical.target" ];
      after = [ "display-manager.service" ];
    };

    dunst = {
      description = "Lightweight libnotify server";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = pkgs.writeScript "dunst" ''
            #! ${pkgs.bash}/bin/bash
            . ${config.system.build.setEnvironment}
            exec ${pkgs.dunst}/bin/dunst -config ${dunstrc}
          '';
        RestartSec = 3;
        Restart = "always";
      };
      wantedBy = [ "display-manager.service" ];
      after = [ "display-manager.service" ];
    };

    feh = {
      description = "Set background";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = pkgs.writeScript "feh" ''
            #! ${pkgs.bash}/bin/bash
            . ${config.system.build.setEnvironment}
            ${pkgs.feh}/bin/feh --bg-fill --no-fehbg ${background-image}
            exec sleep infinity
          '';
        RestartSec = 3;
        Restart = "always";
      };
      wantedBy = [ "display-manager.service" ];
      after = [ "display-manager.service" ];
    };
  };
}
