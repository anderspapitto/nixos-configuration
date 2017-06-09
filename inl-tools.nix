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
            sudo systemctl start compton
            ${emacs}/bin/emacsclient -e '(enable-light-theme)'
        else
            sudo systemctl start compton-night
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
    (writeScriptBin "switch-to-headphones" ''
        #! ${bash}/bin/bash
        set -x
        pacmd set-sink-port alsa_output.pci-0000_00_1b.0.analog-stereo analog-output-headphones
      '')
    (writeScriptBin "switch-to-speakers" ''
        #! ${bash}/bin/bash
        set -x
        pacmd set-sink-port alsa_output.pci-0000_00_1b.0.analog-stereo analog-output-speaker
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
