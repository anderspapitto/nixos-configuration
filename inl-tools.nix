{ config, pkgs, ... }:

with pkgs;

let smart-ghc-mod = writeScriptBin "ghc-mod" ''
        #! ${bash}/bin/bash
        MYROOT=$( ${haskellPackages.ghc-mod}/bin/ghc-mod root )
        if [ -e "$MYROOT/shell.drv" ];
        then
            exec nix-shell-wrapper "$MYROOT/shell.drv" ghc-mod "$@"
        else
            exec ${haskellPackages.ghc-mod}/bin/ghc-mod "$@"
        fi
      '';
    browser = writeScriptBin "browser" ''
        #! ${bash}/bin/bash
        URL=file:///dev/null
        [[ -z "$1" ]] || URL=http://$1
        [[ $1 = http* ]] && URL=$1
        chromium --app=$URL
        exec i3-msg focus tiling
      '';
    starcraft2 = writeScriptBin "starcraft2" ''
        #! ${bash}/bin/bash
        ${wineStaging}/bin/wine "$HOME/.wine/drive_c/Program Files/StarCraft II/Support/SC2Switcher.exe"
      '';
    toggle-invert = writeScriptBin "toggle-invert" ''
        #! ${bash}/bin/bash
        FOO=$( ${xdotool}/bin/xdotool getactivewindow getwindowname )
        if [[ $FOO == *" NOINVERT" ]];
        then
            FOO=''${FOO% NOINVERT};
        else
            FOO="$FOO NOINVERT";
        fi
        ${xdotool}/bin/xdotool getactivewindow set_window --name "$FOO"
      '';
    global-toggle-invert = writeScriptBin "global-toggle-invert" ''
        #! ${bash}/bin/bash

        if systemctl --user is-active compton-night
        then systemctl --user start compton
        else systemctl --user start compton-night
        fi

        ZATHURA=$HOME/config-issue/zathura/.config/zathura
        current=$(readlink $ZATHURA/zathurarc)
        for other in $(ls $ZATHURA); do
            if [[ $current != $other ]];
               then ln -sf $other $ZATHURA/zathurarc;
            fi;
        done

        ${emacs}/bin/emacsclient -e '(toggle-night-color-theme)'
      '';
    status-bar = writeScriptBin "status-bar" ''
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
      '';
    external-drive-mount = writeScriptBin "external-drive-mount" ''
        #! ${bash}/bin/bash
        set -x
        if [[ $EUID -ne 0 ]]; then
           echo "This script must be run as root" 1>&2
           exit 1
        fi
        ${cryptsetup}/bin/cryptsetup --type luks open /dev/sdb external
        mount -t ext4 /dev/mapper/external /mnt
      '';
    external-drive-umount = writeScriptBin "external-drive-umount" ''
        #! ${bash}/bin/bash
        set -x
        if [[ $EUID -ne 0 ]]; then
           echo "This script must be run as root" 1>&2
           exit 1
        fi
        umount /mnt
        ${cryptsetup}/bin/cryptsetup close external
      '';
    backup-homedir = writeScriptBin "backup-homedir" ''
        #! ${bash}/bin/bash
        if [[ $EUID -eq 0 ]]; then
           echo "This script must not be run as root" 1>&2
           exit 1
        fi
        rsync -aAXHv $HOME/* /mnt
      '';

in
{ environment.systemPackages = [
    smart-ghc-mod
    browser starcraft2
    toggle-invert global-toggle-invert
    status-bar
    external-drive-mount external-drive-umount backup-homedir
  ];
}
