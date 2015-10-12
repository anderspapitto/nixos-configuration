{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [ docker ];

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "wlp4s0";
  };

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };
}
