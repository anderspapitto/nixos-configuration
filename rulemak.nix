{ config, pkgs, ... }:

let rulemak = pkgs.fetchFromGitHub {
      owner  = "anderspapitto";
      repo   = "rulemak";
      rev    = "3b9470655c75b65f840ba95686321a61a3f26dca";
      sha256 = "0i6xzmlng3bi42cnhjkrfn1m9cw0xgvfggrcxf3if4k2a5cks152";
    };
    toggle-layout = pkgs.writeScriptBin "toggle-layout" ''
        #! ${pkgs.bash}/bin/bash
        if systemctl --user is-active colemak
        then systemctl --user start rulemak
        else systemctl --user start colemak
        fi
      '';
in {
  systemd.user.services = {
    colemak = {
      description = "Colemak layout";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout us -variant colemak";
        RemainAfterExit = "yes";
      };
      wantedBy = [ "default.target" ];
    };

    rulemak = {
      description = "Rulemak layout";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeScript "rulemak" ''
            #! ${pkgs.bash}/bin/bash
            set -xe
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap -I${rulemak} rulemak -print |
                ${pkgs.xorg.xkbcomp}/bin/xkbcomp -I${rulemak} - :0.0
          '';
        RemainAfterExit = "yes";
      };
      conflicts = [ "colemak.service" ];
    };

  };
  environment.systemPackages = [ toggle-layout ];
}
