{ config, pkgs, ... }:

let pulse = pkgs.pulseaudioFull;
in {
  boot = {
    kernelModules = [ "snd-seq" "snd-rawmidi" ];
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pulse;
  };

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
}
