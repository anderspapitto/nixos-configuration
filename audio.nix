{ config, pkgs, pkgs_i686, ... }:

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
  environment.systemPackages = with pkgs; [ pulse ];

  environment.etc = [
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

  services.mpd.enable = true;
}
