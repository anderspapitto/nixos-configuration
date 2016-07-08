{ config, pkgs, ... }:

{ systemd.services.dropbox = {
    description = "Dropbox";
    environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash --login -c 'exec ${pkgs.dropbox}/bin/dropbox'";
      User = "anders";
    };
    wantedBy = [ "graphical.target" ];
  };
}
