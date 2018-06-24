{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
  (writeScriptBin "anders-handle-keybind" ''
      #! ${bash}/bin/bash

      case $1 in
      F1)
        pactl set-sink-mute   @DEFAULT_SINK@ toggle
        killall -SIGUSR1 i3status
        ;;
      F2)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        killall -SIGUSR1 i3status
        ;;
      F3)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        killall -SIGUSR1 i3status
        ;;
      F7)
        exec systemctl suspend
        ;;
      F9)
        exec browser
        ;;
      F10)
        exec anders-capture
        ;;
      F11)
        exec i3-rename
        ;;
      F12)
        exec i3-switch
        ;;
      esac
    '')
  (writeScriptBin "i3-switch" ''
      #! ${bash}/bin/bash

      set -e

      list_workspaces() {
        ${i3}/bin/i3-msg -t get_workspaces | ${jq}/bin/jq -r '.[] | .name'
      }

      WORKSPACE=$( list_workspaces | rofi -dmenu -p "switch to workspace " )

      i3-msg workspace "$WORKSPACE"
    '')
  (writeScriptBin "i3-rename" ''
      #! ${bash}/bin/bash

      set -e

      NAME=$( rofi -dmenu -p "rename workspace to " )

      i3-msg "rename workspace to $NAME"
    '')
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
          sudo systemctl start compton
      else
          sudo systemctl start compton-night
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
    # TODO remove my-pager in favor of anders-pager once i've rebooted
  (writeScriptBin "my-pager" ''
      #! ${bash}/bin/bash
      if [[ $TERM = dumb ]]; then
        exec cat "$@"
      else
        exec less -R "$@"
      fi
    '')
  (writeScriptBin "anders-pager" ''
      #! ${bash}/bin/bash
      if [[ $TERM = dumb ]]; then
        exec cat "$@"
      else
        exec less -R "$@"
      fi
    '')
  (writeScriptBin "disable-bluetooth" ''
      #! ${bash}/bin/bash
      set -x

      export XDG_RUNTIME_DIR=/run/user/$UID

      bluetoothctl <<< 'power off'
    '')
  (writeScriptBin "audio-bluetooth" ''
      #! ${bash}/bin/bash
      set -x

      export XDG_RUNTIME_DIR=/run/user/$UID

      TRIES=0
      until (bluetoothctl <<< show | grep -q 'Powered: yes')
      do
        bluetoothctl <<< 'power on'
        [[ $((TRIES++)) -eq 20 ]] && exit 1
        sleep 0.1
      done

      TRIES=0
      until [ -n "$DEVICE" ]
      do
        DEVICE=$(bluetoothctl <<< devices | egrep '^Device.*OontZ' | awk '{ print $2 }')
        [[ $((TRIES++)) -eq 20 ]] && exit 1
        sleep 0.1
      done

      TRIES=0
      until bluetoothctl <<< "connect $DEVICE"
      do
        [[ $((TRIES++)) -eq 20 ]] && exit 1
        sleep 0.1
      done

      TRIES=0
      until [ -n "$TARGET_CARD" ]
      do
        TARGET_CARD=$(pacmd list-cards | grep 'name:' | egrep -o 'bluez.*[^>]')
        [[ $((TRIES++)) -eq 20 ]] && exit 1
        sleep 0.1
      done

      TRIES=0
      until pacmd list-cards | egrep -q 'active profile: <a2dp_sink>'
      do
        pacmd set-card-profile $TARGET_CARD a2dp_sink
        [[ $((TRIES++)) -eq 20 ]] && exit 1
        sleep 0.1
      done

      TRIES=0
      until [ -n "$TARGET_SINK" ]
      do
        TARGET_SINK=$(pacmd list-sinks | grep 'name:' | egrep -o 'bluez.*[^>]')
        [[ $((TRIES++)) -eq 20 ]] && exit 1
        sleep 0.1
      done

      pactl set-sink-volume $TARGET_SINK 50%
      pacmd set-default-sink $TARGET_SINK

      for index in $(pacmd list-sink-inputs $TARGET_SINK | grep index | awk '{ print $2 }')
      do
          pacmd move-sink-input $index $TARGET_SINK
      done
    '')
  (writeScriptBin "bluetooth-off" ''
      #! ${bash}/bin/bash
      set -x
      bluetoothctl <<< 'power off'
    '')
  (writeScriptBin "dark-mode" ''
      #! ${bash}/bin/bash
      set -x
      ${redshift}/bin/redshift -O 2000
      /run/wrappers/bin/sudo ${coreutils}/bin/tee /sys/class/backlight/intel_backlight/brightness <<< 250
    '')
  (writeScriptBin "twilight-mode" ''
      #! ${bash}/bin/bash
      set -x
      ${redshift}/bin/redshift -O 2500
      /run/wrappers/bin/sudo ${coreutils}/bin/tee /sys/class/backlight/intel_backlight/brightness <<< 500
    '')
  (writeScriptBin "light-mode" ''
      #! ${bash}/bin/bash
      set -x
      ${redshift}/bin/redshift -x
      /run/wrappers/bin/sudo ${coreutils}/bin/tee /sys/class/backlight/intel_backlight/brightness <<< 852
    '')

#     (writeScriptBin "switch-to-headphones" ''
#         #! ${bash}/bin/bash
#         set -x
#         pacmd set-sink-port alsa_output.pci-0000_00_1b.0.analog-stereo analog-output-headphones
#       '')
#     (writeScriptBin "switch-to-speakers" ''
#         #! ${bash}/bin/bash
#         set -x
#         pacmd set-sink-port alsa_output.pci-0000_00_1b.0.analog-stereo analog-output-speaker
#       '')
#     (writeScriptBin "toggle-suspend-audio" ''
#         #! ${bash}/bin/bash
#         pacmd list-sinks | grep state: | grep -v -q SUSPENDED
#         if [[ $? -eq 0 ]]
#         then
#             pacmd suspend 1
#         else
#             pacmd suspend 0
#         fi
#       '')
  ];

  environment.variables = { PAGER = "anders-pager"; };
}
