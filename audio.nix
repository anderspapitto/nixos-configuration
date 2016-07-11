{ config, pkgs, pkgs_i686, ... }:

# let pulse = pkgs.pulseaudioLight.override { jackaudioSupport = true; };
let pulse = pkgs.pulseaudioFull.out;
    clientConf = ''
        autospawn=yes
        daemon-binary=${pulse}/bin/pulseaudio
      '';
    alsaConf   = ''
        pcm_type.pulse {
          libs.native = ${pkgs.     alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so ;
          libs.32Bit  = ${pkgs_i686.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so ;
        }
        pcm.!default {
          type pulse
          hint.description "Default Audio Device (via PulseAudio)"
        }
        ctl_type.pulse {
          libs.native = ${pkgs.     alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so ;
          libs.32Bit  = ${pkgs_i686.alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so ;
        }
        ctl.!default {
          type pulse
        }
      '';
in {
  boot = {
    kernelModules = [ "snd-seq" "snd-rawmidi" ];
  };

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile";  type = "-"; value = "99999"; }
  ];

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [ pulse jack2Full ];

  environment.etc = [
    { target = "jackdrc";
      text = "${pkgs.jack2Full}/bin/jackdbus -dalsa -r48000 -p1024 -n2 -D -Chw:PCH,0 -Phw:PCH,0";
    }
    { target = "pulse/client.conf";
      text = clientConf;
    }
    { target = "asound.conf";
      text = alsaConf;
    }
    { target = "pulse/default.pa";
      source = "${pulse}/etc/pulse/default.pa";
    }
  ];

  systemd.sockets.pulseaudio = {
    description = "Pulseaudio Socket";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      Priority = 6;
      Backlog = 5;
      ListenStream = "%t/pulse/native";
    };
  };

  systemd.services = {
    pulseaudio = {
      description = "PulseAudio Server";
      wantedBy = [ "sound.target" ];
      after = [ "display-manager.service" ];
      serviceConfig = {
        Type = "notify";
        User = "anders";
        ExecStart = "${pulse}/bin/pulseaudio --daemonize=no";
      };
      environment = {
        DISPLAY = ":${toString config.services.xserver.display}";
        HOME = "/home/anders";
      };
    };
    jackdbus = {
      description = "Runs jack, and points pulseaudio at it";
      # wantedBy = [ "sound.target" ];
      requires = [ "pulseaudio.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "anders";
        ExecStart = pkgs.writeScript "start_jack" ''
          #! ${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}

          ${pkgs.jack2Full}/bin/jack_control start
          ${pkgs.jack2Full}/bin/jack_control dps device hw:PCH,0
          ${pulse}/bin/pacmd set-default-sink jack_out
          ${pulse}/bin/pacmd set-default-source jack_in

          SINK=$( ${pulse}/bin/pacmd list-sinks |
                  ${pkgs.gnugrep}/bin/grep -oE 'alsa_output.*analog-stereo')
          ${pulse}/bin/pactl suspend-sink $SINK 1
        '';
        ExecStop = pkgs.writeScript "stop_jack" ''
          #! ${pkgs.bash}/bin/bash
          . ${config.system.build.setEnvironment}

          SINK=$( ${pulse}/bin/pacmd list-sinks |
                  ${pkgs.coreutils}/bin/grep -oE 'alsa_output.*analog-stereo')
          ${pulse}/bin/pactl suspend-sink $SINK 0

          ${pkgs.jack2Full}/bin/jack_control stop
        '';
        RemainAfterExit = true;
      };
      environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
    };
  };
}
