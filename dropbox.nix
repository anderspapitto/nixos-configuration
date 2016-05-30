{ config, pkgs, ... }:
{ systemd.user.services.dropbox = {
    description = "Dropbox";
    serviceConfig = {
      Type = "simple";
      ExecStart = pkgs.writeScript "dropbox" ''
        #! ${pkgs.bash}/bin/bash
        . ${config.system.build.setEnvironment}
        exec ${pkgs.dropbox}/bin/dropbox
      '';
      RestartSec = 3;
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
  };
}
