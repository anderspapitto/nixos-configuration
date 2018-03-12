{ config, pkgs, ... }:

{ services.syncthing = {
    enable = true;
    user = "anders";
    dataDir = "/home/anders/.syncthing";
    openDefaultPorts = true;
  };
}
