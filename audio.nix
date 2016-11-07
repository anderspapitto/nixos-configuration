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
    configFile = pkgs.writeText "default.pa" ''
        load-module module-udev-detect
        load-module module-jackdbus-detect channels=2
        load-module module-bluetooth-policy
        load-module module-bluetooth-discover
        load-module module-esound-protocol-unix
        load-module module-native-protocol-unix
        load-module module-always-sink
        load-module module-console-kit
        load-module module-systemd-login
        load-module module-intended-roles
        load-module module-position-event-sounds
        load-module module-filter-heuristics
        load-module module-filter-apply
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

  systemd.services = {
    switch-to-jackdbus-for-suspend = {
      description = "Move all sink-inputs to jack sink before suspend";
      environment = {
        DISPLAY = ":${toString config.services.xserver.display}";
        PULSE_RUNTIME_PATH = "/run/user/1000/pulse";
      };
      serviceConfig = {
        Type = "oneshot";
        User = "anders";
        ExecStart = pkgs.writeScript "battery_check" ''
            #!${pkgs.bash}/bin/bash --login
            . ${config.system.build.setEnvironment}
            switch-to-jack
          '';
      };
      wantedBy = [ "suspend.target" ];
    };
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
