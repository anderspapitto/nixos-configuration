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
            xrdb ${builtins.toFile "Xresources" (builtins.readFile ./config/xresources)}
          '';
          configFile = let
            i3status-conf = builtins.unsafeDiscardStringContext (builtins.toFile
              "i3status-conf" (builtins.readFile ./config/i3status));
          in builtins.toFile "i3-config" (pkgs.lib.replaceStrings
              [ "i3status.conf" ]
              [ "${i3status-conf}" ]
              (builtins.readFile ./config/i3));
        };
        default = "i3-gaps";
      };
      desktopManager.xterm.enable = false;
      synaptics = {
        enable = true;
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
      };
      wantedBy = [ "display-manager" ];
      after = [ "display-manager" ];
    };

    xbanish = {
      description = "xbanish hides the mouse pointer";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = "${pkgs.xbanish}/bin/xbanish";
      };
      wantedBy = [ "display-manager" ];
      after = [ "display-manager" ];
    };

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
      wantedBy = [ "display-manager" ];
      after = [ "display-manager" ];
    };
  };
}
