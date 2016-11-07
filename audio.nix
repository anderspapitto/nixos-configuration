{ config, pkgs, pkgs_i686, ... }:

let pulse = pkgs.pulseaudioFull;
in {
  boot = {
    kernelModules = [ "snd-seq" "snd-rawmidi" ];
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pulse;
    extraConfig = ''
        load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
      '';
  };

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile";  type = "-"; value = "99999"; }
  ];

  security.rtkit.enable = true;

  services.mpd = {
    enable = true;
    user = "anders";
    group = "users";
    musicDirectory = "/home/anders/Music";
    dataDir = "/home/anders/.mpd";
    extraConfig = ''
        audio_output {
          type    "pulse"
          name    "Local MPD"
          server  "127.0.0.1"
        }
      '';
  };

  environment.etc = [
    { target = "jackdrc";
      text = "${pkgs.jack2Full}/bin/jackdbus -dalsa -r48000 -p1024 -n2 -D -Chw:PCH,0 -Phw:PCH,0";
    }
  ];

  environment.systemPackages = with pkgs; [
    ardour
    hydrogen
    jack2Full
  ];
}



#   systemd.sockets.pulseaudio = {
#     description = "Pulseaudio Socket";
#     wantedBy = [ "sockets.target" ];
#     socketConfig = {
#       Priority = 6;
#       Backlog = 5;
#       ListenStream = "%t/pulse/native";
#     };
#   };
#
#   systemd.services = {
#     pulseaudio = {
#       description = "PulseAudio Server";
#       wantedBy = [ "sound.target" ];
#       after = [ "display-manager.service" ];
#       serviceConfig = {
#         Type = "notify";
#         User = "anders";
#         ExecStart = "${pulse}/bin/pulseaudio --daemonize=no";
#       };
#       environment = {
#         DISPLAY = ":${toString config.services.xserver.display}";
#         HOME = "/home/anders";
#       };
#     };
#     jackdbus = {
#       description = "Runs jack, and points pulseaudio at it";
#       # wantedBy = [ "sound.target" ];
#       requires = [ "pulseaudio.service" ];
#       serviceConfig = {
#         Type = "oneshot";
#         User = "anders";
#         ExecStart = pkgs.writeScript "start_jack" ''
#           #! ${pkgs.bash}/bin/bash
#           . ${config.system.build.setEnvironment}
#
#           ${pkgs.jack2Full}/bin/jack_control start
#           ${pkgs.jack2Full}/bin/jack_control dps device hw:PCH,0
#           ${pulse}/bin/pacmd set-default-sink jack_out
#           ${pulse}/bin/pacmd set-default-source jack_in
#
#           SINK=$( ${pulse}/bin/pacmd list-sinks |
#                   ${pkgs.gnugrep}/bin/grep -oE 'alsa_output.*analog-stereo')
#           ${pulse}/bin/pactl suspend-sink $SINK 1
#         '';
#         ExecStop = pkgs.writeScript "stop_jack" ''
#           #! ${pkgs.bash}/bin/bash
#           . ${config.system.build.setEnvironment}
#
#           SINK=$( ${pulse}/bin/pacmd list-sinks |
#                   ${pkgs.coreutils}/bin/grep -oE 'alsa_output.*analog-stereo')
#           ${pulse}/bin/pactl suspend-sink $SINK 0
#
#           ${pkgs.jack2Full}/bin/jack_control stop
#         '';
#         RemainAfterExit = true;
#       };
#       environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
#     };
#   };
# }
