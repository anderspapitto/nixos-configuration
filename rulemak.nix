{ config, pkgs, ... }:

let rulemak = pkgs.fetchFromGitHub {
      owner  = "anderspapitto";
      repo   = "rulemak";
      rev    = "3b9470655c75b65f840ba95686321a61a3f26dca";
      sha256 = "0i6xzmlng3bi42cnhjkrfn1m9cw0xgvfggrcxf3if4k2a5cks152";
    };
    toggle-layout = pkgs.writeScriptBin "toggle-layout" ''
        #! ${pkgs.bash}/bin/bash
        if systemctl is-active colemak
        then systemctl start rulemak
        else systemctl start colemak
        fi
      '';
in {
  systemd.services = {
    colemak = {
      description = "Colemak layout";
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = pkgs.writeScript "colemak" ''
            #! ${pkgs.bash}/bin/bash
            set -xe
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout us -variant colemak
            exec sleep infinity
          '';
        RemainAfterExit = "yes";
        RestartSec = 3;
        Restart = "always";
      };
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      wantedBy = [ "display-manager.service" ];
      after = [ "display-manager.service" ];
    };

    rulemak = {
      description = "Rulemak layout";
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = pkgs.writeScript "rulemak" ''
            #! ${pkgs.bash}/bin/bash
            set -xe
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap -I${rulemak} rulemak -print |
                ${pkgs.xorg.xkbcomp}/bin/xkbcomp -I${rulemak} - :0.0
            exec sleep infinity
          '';
        RemainAfterExit = "yes";
      };
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      conflicts = [ "colemak.service" ];
      after = [ "display-manager.service" ];
    };

  };
  environment.systemPackages = [ toggle-layout ];
}
