{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    (writeScriptBin "browser" ''
        #! ${bash}/bin/bash
        firefox "$@"
        exec i3-msg focus tiling
      '')
    (writeScriptBin "toggle-invert" ''
        #! ${bash}/bin/bash
        FOO=$( ${xdotool}/bin/xdotool getactivewindow getwindowname )
        if [[ $FOO == *" NOINVERT" ]];
        then
            FOO=''${FOO% NOINVERT};
        else
            FOO="$FOO NOINVERT";
        fi
        ${xdotool}/bin/xdotool getactivewindow set_window --name "$FOO"
      '')
    (writeScriptBin "global-toggle-invert" ''
        #! ${bash}/bin/bash
        . ${config.system.build.setEnvironment}

        if systemctl is-active compton-night > /dev/null
        then
            systemctl start compton
            ${emacs}/bin/emacsclient -e '(enable-light-theme)'
        else
            systemctl start compton-night
            ${emacs}/bin/emacsclient -e '(enable-dark-theme)'
        fi
      '')
    (writeScriptBin "external-drive-mount" ''
        #! ${bash}/bin/bash
        set -x
        if [[ $EUID -ne 0 ]]; then
           echo "This script must be run as root" 1>&2
           exit 1
        fi
        ${cryptsetup}/bin/cryptsetup --type luks open /dev/sdb external
        mount -t ext4 /dev/mapper/external /mnt
      '')
    (writeScriptBin "external-drive-umount" ''
        #! ${bash}/bin/bash
        set -x
        if [[ $EUID -ne 0 ]]; then
           echo "This script must be run as root" 1>&2
           exit 1
        fi
        umount /mnt
        ${cryptsetup}/bin/cryptsetup close external
      '')
    (writeScriptBin "backup-homedir" ''
        #! ${bash}/bin/bash
        if [[ $EUID -eq 0 ]]; then
           echo "This script must not be run as root" 1>&2
           exit 1
        fi
        rsync -aAXHv $HOME/* /mnt
      '')
    (writeScriptBin "my-pager" ''
        #! ${bash}/bin/bash
        if [[ $TERM = dumb ]]; then
          exec cat "$@"
        else
          exec less -R "$@"
        fi
      '')
    (writeScriptBin "restart-jack" ''
        #! ${bash}/bin/bash
        jack_control exit
        sleep 0.5
        jack_control start
        switch-to-jack
      '')
    (writeScriptBin "switch-to-jack" ''
        #! ${bash}/bin/bash

        set -x

        until pacmd list-sinks | egrep -q 'jack_out'
        do
            jack_control start
        done

        pactl set-sink-volume jack_out 100%

        pacmd set-default-sink jack_out
        for index in $(pacmd list-sink-inputs | grep index | awk '{ print $2 }')
        do
            pacmd move-sink-input $index jack_out
        done
      '')
    (writeScriptBin "switch-to-bluetooth" ''
        #! ${bash}/bin/bash

        set -x

        DEVICE=$(bluetoothctl <<< devices | egrep '^Device' | awk '{ print $2 }')
        until bluetoothctl <<< show | grep -q 'Powered: yes'
        do
            bluetoothctl <<< 'power on'
        done
        until pacmd list-sinks | egrep -q 'name:.*bluez_sink'
        do
            bluetoothctl <<< "connect $DEVICE"
        done

        TARGET_CARD=$(pacmd list-cards | grep 'name:' | egrep -o 'bluez.*[^>]')
        TARGET_SINK=$(pacmd list-sinks | grep 'name:' | egrep -o 'bluez.*[^>]')

        until pacmd list-cards | egrep -q 'active profile: <a2dp_sink>'
        do
            pacmd set-card-profile $TARGET_CARD a2dp_sink
        done


        pactl set-sink-volume $TARGET_SINK 30%
        pacmd set-default-sink $TARGET_SINK
        for index in $(pacmd list-sink-inputs | grep index | awk '{ print $2 }')
        do
            pacmd move-sink-input $index $TARGET_SINK
        done
      '')
    (writeScriptBin "switch-to-stereo" ''
        #! ${bash}/bin/bash

        set -x

        TARGET_SINK=$(pacmd list-sinks | grep 'name:' | egrep -o 'alsa.*analog-stereo')

        pactl set-sink-volume $TARGET_SINK 50%

        jack_control stop

        pacmd set-default-sink $TARGET_SINK
        for index in $(pacmd list-sink-inputs | grep index | awk '{ print $2 }')
        do
            pacmd move-sink-input $index $TARGET_SINK
        done
      '')
    (writeScriptBin "toggle-suspend-audio" ''
        #! ${bash}/bin/bash
        pacmd list-sinks | grep state: | grep -v -q SUSPENDED
        if [[ $? -eq 0 ]]
        then
            pacmd suspend 1
        else
            pacmd suspend 0
        fi
      '')
  ];

  environment.variables = { PAGER = "my-pager"; };
}
