{ config, pkgs, ... }:

{ services.syncthing = {
    enable = true;
    user = "anders";
    dataDir = "/home/anders/sync";
  };
}
