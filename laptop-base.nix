{ config, pkgs, ... }:

{ hardware = {
    opengl.driSupport32Bit = true; # needed for steam and/or wine, i believe
  };

  services = {
    acpid.enable = true;

    logind.extraConfig = ''
      HoldoffTimeoutSec=0
    '';
  };

  users.extraUsers.anders = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "docker" ];
  };
}
