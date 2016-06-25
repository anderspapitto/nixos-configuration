{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    (writeScriptBin "browser" ''
        #! ${bash}/bin/bash
        URL=file:///dev/null
        [[ -z "$1" ]] || URL=http://$1
        [[ $1 = http* ]] && URL=$1
        chromium --app=$URL
        exec i3-msg focus tiling
      '')
    (writeScriptBin "starcraft2" ''
        #! ${bash}/bin/bash
        ${wineStaging}/bin/wine "$HOME/.wine/drive_c/Program Files/StarCraft II/Support/SC2Switcher.exe"
      '')
    (writeScriptBin "flstudio" ''
        #! ${bash}/bin/bash
        ${wineStaging}/bin/wine "$HOME/.wine/drive_c/Program Files/Image-Line/FL Studio 12/FL.exe"
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

        if systemctl --user is-active compton-night > /dev/null
        then systemctl --user start compton
        else systemctl --user start compton-night
        fi

        ${emacs}/bin/emacsclient -e '(toggle-night-color-theme)'
      '')
    (writeScriptBin "status-bar" ''
        #! ${bash}/bin/bash

        index_in() {
            sed -n 1p
        }

        get_vol() {
            if pactl list sinks | grep 'Mute:' | index_in | grep -q 'yes';
            then echo -n '(Mute) ';
            fi
            pactl list sinks | grep 'Volume: front' | index_in | awk '{print $5}' | tr -d '\n'
        }

        i3status --config ~/.i3/i3status.conf | (read line && echo $line && read line && echo $line && while :
        do
            read line
            vol=$(get_vol)
            formatted_vol="{ \"full_text\": \"''${vol}\" }"
            echo "''${line/[/[''${formatted_vol},}" || exit 1
        done)
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
  ];
}
