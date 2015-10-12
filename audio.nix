{ config, pkgs, ... }:

let pulse = pkgs.pulseaudioLight.override { jackaudioSupport = true; };
in {
  hardware.pulseaudio = {
    enable = true;
    package = pulse;
    support32Bit = true;
  };

  environment.systemPackages = with pkgs; [ jack2Full ];

  systemd.user.services = {
    jackdbus = {
      description = "Runs jack, and points pulseaudio at it";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeScript "start_jack" ''
          #! ${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}
          ${pkgs.jack2Full}/bin/jack_control start
          sleep 10
          ${pulse}/bin/pacmd set-default-sink jack_out
          ${pulse}/bin/pacmd set-default-source jack_in
        '';
        ExecStop = pkgs.writeScript "stop_jack" ''
          #! ${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}
          ${pkgs.jack2Full}/bin/jack_control stop
        '';
        RemainAfterExit = true;
      };
      wantedBy = [ "default.target" ];
    };

  #  dirt = {
  #    description = "Runs dirt server";
  #    serviceConfig = {
  #      ExecStart = "${pkgs.dirt}/bin/dirt";
  #    };
  #  };
  };
}
