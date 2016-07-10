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

  systemd.services.battery_check = {
    description = "Send notification if battery is low";
    serviceConfig = {
      Type = "oneshot";
      User = "anders";
      ExecStart = pkgs.writeScript "battery_check" ''
        #!${pkgs.bash}/bin/bash --login
        . <(udevadm info -q property -p /sys/class/power_supply/BAT0 |
            grep -E 'POWER_SUPPLY_(CAPACITY|STATUS)=')
        if [[ $POWER_SUPPLY_STATUS = Discharging && $POWER_SUPPLY_CAPACITY -lt 15 ]];
        then notify-send -u critical "Battery is low: $POWER_SUPPLY_CAPACITY";
        fi
      '';
    };
    environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
    startAt = "*:00/5";
  };

  users.extraUsers.anders = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "docker" ];
  };
}
