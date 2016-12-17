{ config, pkgs, ... }:

{ systemd.services.dropbox = {
    description = "Dropbox";
    environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash --login -c 'exec ${pkgs.dropbox}/bin/dropbox'";
      User = "anders";
      RestartSec = 3;
      Restart = "always";
    };
    wantedBy = [ "graphical.target" ];
    after = [ "display-manager.service" ];
  };
}
