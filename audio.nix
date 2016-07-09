{ config, pkgs, ... }:

# let pulse = pkgs.pulseaudioLight.override { jackaudioSupport = true; };
let pulse = pkgs.pulseaudioFull;
in {
  boot = {
    kernelModules = [ "snd-seq" "snd-rawmidi" ];
  };

  hardware.pulseaudio = {
    enable = true;
    package = pulse;
    support32Bit = true;
  };

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile";  type = "-"; value = "99999"; }
  ];

  environment.systemPackages = with pkgs; [ jack2Full ];

  environment.etc.jackdrc.text = ''
    ${pkgs.jack2Full}/bin/jackdbus -dalsa -r48000 -p1024 -n2 -D -Chw:PCH,0 -Phw:PCH,0
  '';

  systemd.user.services = {
    jackdbus = {
      description = "Runs jack, and points pulseaudio at it";
#      wantedBy = [ "default.target" ];
      requires = [ "pulseaudio.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeScript "start_jack" ''
          #! ${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}

          ${pkgs.jack2Full}/bin/jack_control start
          ${pkgs.jack2Full}/bin/jack_control dps device hw:PCH,0
          ${pulse.out}/bin/pacmd set-default-sink jack_out
          ${pulse.out}/bin/pacmd set-default-source jack_in

          SINK=$( ${pulse.out}/bin/pacmd list-sinks |
                  ${pkgs.gnugrep}/bin/grep -oE 'alsa_output.*analog-stereo')
          ${pulse.out}/bin/pactl suspend-sink $SINK 1
        '';
        ExecStop = pkgs.writeScript "stop_jack" ''
          #! ${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}

          SINK=$( ${pulse.out}/bin/pacmd list-sinks |
                  ${pkgs.coreutils}/bin/grep -oE 'alsa_output.*analog-stereo')
          ${pulse.out}/bin/pactl suspend-sink $SINK 0

          ${pkgs.jack2Full}/bin/jack_control stop
        '';
        RemainAfterExit = true;
      };
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
    };
  };
}
