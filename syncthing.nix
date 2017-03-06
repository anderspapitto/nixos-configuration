{ config, pkgs, ... }:

{ services.syncthing = {
    enable = true;
    useInotify = true;
    user = "anders";
    dataDir = "/home/anders/.syncthing";
    openDefaultPorts = true;
  };
}
