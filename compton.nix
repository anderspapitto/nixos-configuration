{ config, pkgs, ... }:

let compton-inverted    = builtins.toFile "inverted"    (builtins.readFile ./config/compton-inverted);
    compton-noninverted = builtins.toFile "noninverted" (builtins.readFile ./config/compton-noninverted);
in {
  systemd.services = {
    compton = {
      description = "Compton: the lightweight compositing manager";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = "${pkgs.compton}/bin/compton -cCG --config ${compton-noninverted}";
      };
      after = [ "display-manager.service" ];
    };

    compton-night = {
      description = "Compton: the lightweight compositing manager";
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
      serviceConfig = {
        Type = "simple";
        User = "anders";
        ExecStart = "${pkgs.compton}/bin/compton -cCG --config ${compton-inverted}";
      };
      conflicts = [ "compton.service" ];
      after = [ "display-manager.service" ];
    };
  };
}
