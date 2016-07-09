{ config, pkgs, ... }:

let dunstrc = builtins.toFile "dunstrc" (pkgs.lib.readFile ./config/dunstrc);

in {
  services = {
    xserver = {
      enable = true;
      layout = "us";
      # note typo in base.lst, where it says 'ctrl:ctrl_ralt' when it
      # means 'ctrl:ralt_rctrl'
      xkbOptions = "ctrl:ralt_rctrl, lv3:caps_switch, shift:both_capslock";
      xkbVariant = "colemak";
      displayManager = {
        slim.theme = pkgs.stdenv.mkDerivation {
          name = "nixos-solarized-theme";
          src = pkgs.fetchFromGitHub {
            owner = "anderspapitto";
            repo = "nixos-solarized-slim-theme";
            rev = "2822b7cb7074cf9aa36afa9b5cabd54105b3306c";
            sha256 = "0jp7qq02ly9wiqbgh5yamwd31ah1bbybida7mn1g6qpdijajf247";
          };
          installPhase = ''cp -R . "$out"'';
        };
      };
      windowManager = {
        i3-gaps = {
          enable = true;
          extraSessionCommands = ''
            ${pkgs.gnupg}/bin/gpg-connect-agent /bye
            export GPG_TTY=$(tty)
          '';
        };
        default = "i3-gaps";
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

    xbanish = {
      enable = true;
    };
  };

  systemd.services = {
    dunst = {
      description = "Lightweight libnotify server";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = pkgs.writeScript "dunst" ''
          #!${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}
          exec ${pkgs.dunst}/bin/dunst -config ${dunstrc}
        '';
      };
      wantedBy = [ "graphical.target" ];
    };
  };
}
