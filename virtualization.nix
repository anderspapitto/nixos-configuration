{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    # docker
  ];

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "wlan0";
  };

  virtualisation = {
    # docker.enable = true;
  };
}
