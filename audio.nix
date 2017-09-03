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

        load-module module-null-sink sink_name=NullSink
        update-sink-proplist NullSink device.description=NullSink
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
    jack = {
      description = "Run the jack server";
      environment = {
        DISPLAY = ":${toString config.services.xserver.display}";
      };
      serviceConfig = {
        Type = "dbus";
        User = "anders";
        BusName = "org.jackaudio.Controller";
        RemainAfterExit = "yes";
        ExecStart = "${pkgs.jack2Full}/bin/jack_control start";
        ExecStop  = "${pkgs.jack2Full}/bin/jack_control stop";
      };
      before = [ "sound.target" "pulseaudio.service" ];
      requires = [ "dbus.socket" ];
      wantedBy = [ "sound.target" ];
    };

    pulse-into-jack = {
      description = "Redirect Pulse into Jack";
      environment = {
        DISPLAY = ":${toString config.services.xserver.display}";
        PULSE_RUNTIME_PATH = "/run/user/1000/pulse";
      };
      serviceConfig = {
        Type = "oneshot";
        User = "anders";
        RemainAfterExit = "yes";
        ExecStart = pkgs.writeScript "pulse-into-jack-start" ''
            #!${pkgs.bash}/bin/bash --login
            . ${config.system.build.setEnvironment}

            set -xe

            pacmd list-sinks | egrep -q 'jack_out'

            # not really necessary. leaving it in mostly as reminder
            pactl set-sink-volume jack_out 100%

            pacmd set-default-sink jack_out
            for index in $(pacmd list-sink-inputs | grep index | awk '{ print $2 }')
            do
                pacmd move-sink-input $index jack_out
            done
          '';
      };
      before = [ "sound.target" ];
      requires = [ "jack.service" ];
      wantedBy = [ "sound.target" ];

#      serviceConfig = {
#        Type = "simple";
#        User = "anders";
#        ExecStart = pkgs.writeScript "jack-start" ''
#            #!${pkgs.bash}/bin/bash --login
#            . ${config.system.build.setEnvironment}
#
#            set -x
#
#            (pacmd list-sinks | egrep -q 'jack_out') && exit 0
#
#            until pacmd list-sinks | egrep -q 'jack_out'
#            do
#                jack_control start
#            done
#
#            pactl set-sink-volume jack_out 50%
#
#            pacmd set-default-sink jack_out
#            for index in $(pacmd list-sink-inputs | grep index | awk '{ print $2 }')
#            do
#                pacmd move-sink-input $index jack_out
#            done
#            sleep infinity
#          '';
#        ExecStop = pkgs.writeScript "jack-stop" ''
#            #!${pkgs.bash}/bin/bash --login
#            . ${config.system.build.setEnvironment}
#
#            set -x
#
#            (jack_control status | egrep -q 'stopped') && exit 0
#
#            echo foo
#            (jack_control exit) || true
#            echo bar
#
#            while pacmd list-sinks | egrep -q 'jack_out'
#            do
#                true
#            done
#          '';
#      };
    };
  };

#  systemd.services = {
#    switch-to-stereo-for-bluetooth-exit = {
#      description = "Move all sink-inputs to stereo sink before suspend";
#      environment = {
#        DISPLAY = ":${toString config.services.xserver.display}";
#        PULSE_RUNTIME_PATH = "/run/user/1000/pulse";
#      };
#      serviceConfig = {
#        Type = "oneshot";
#        User = "anders";
#        ExecStart = pkgs.writeScript "switch-to-stereo-for-bluetooth-exit" ''
#            #!${pkgs.bash}/bin/bash --login
#            . ${config.system.build.setEnvironment}
#            switch-to-stereo-no-stop-jack
#          '';
#      };
#      wantedBy = [ "sleep.target" "suspend.target" ];
#      before = [ "sleep.target" "suspend.target" ];
#    };
#  };

  environment.etc = [
    { target = "jackdrc";
      text = "${pkgs.jack2Full}/bin/jackdbus -dalsa -r48000 -p1024 -n2 -D -Chw:PCH,0 -Phw:PCH,0";
    }
  ];

  environment.systemPackages = with pkgs; [
    a2jmidid
    # ardour
    drumgizmo
    hydrogen
    jack2Full
    # linVst
    patchage
    zynaddsubfx
    (import ./reaper.nix pkgs)
  ];

  nixpkgs.overlays = [
    (import /etc/nixos/overlays/lin-vst/default.nix)
  ];
}
