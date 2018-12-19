{ config, pkgs, ... }:

let
  physexec = pkgs.writeScriptBin "physexec" ''
      #! ${pkgs.bash}/bin/bash
      exec sudo -E ${pkgs.iproute}/bin/ip netns exec physical \
           sudo -E -u \#$(${pkgs.coreutils}/bin/id -u) \
                   -g \#$(${pkgs.coreutils}/bin/id -g) \
                   "$@"
    '';
  anders-i3status = pkgs.writeScriptBin "anders-i3status" ''
      #! ${pkgs.python3}/bin/python -u

      import os
      import signal
      import subprocess

      # https://stackoverflow.com/questions/320232/ensuring-subprocesses-are-dead-on-exiting-python-program
      os.setpgrp() # create new process group, become its leader
      try:
        p1 = subprocess.Popen(['physexec', 'i3status', '-c', '/etc/i3/status-netns'],
                              stdout=subprocess.PIPE)
        p2 = subprocess.Popen([            'i3status', '-c', '/etc/i3/status'],
                              stdout=subprocess.PIPE)

        for i in range(2):
          line1 = p1.stdout.readline().decode('utf-8').strip()
          line2 = p2.stdout.readline().decode('utf-8').strip()
          print(line1)
        while True:
          line1 = p1.stdout.readline().decode('utf-8').strip()
          line2 = p2.stdout.readline().decode('utf-8').strip()
          print(line1.split(']')[0] + ', ' + line2.split('[')[1])
      finally:
        os.killpg(0, signal.SIGKILL) # kill all processes in my group
    '';
in {
  # There's not really a better way to do this. Override these two services to
  # be wg-aware
  imports = [
    ./copied/dhcpcd.nix
    ./copied/wpa_supplicant.nix
  ];
  disabledModules = [
    "services/networking/dhcpcd.nix"
    "services/networking/wpa_supplicant.nix"
  ];

  environment.systemPackages = [ pkgs.wireguard physexec anders-i3status ];

  networking.wireless.interfaces = [ "wlp4s0" ];

  systemd.services = {
    physical-netns = {
      description = "physical namespace, for use with wireguard";
      wantedBy = [ "default.target" ];
      before = [ "display-manager.service" "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute}/bin/ip netns add physical";
        ExecStop = "${pkgs.iproute}/bin/ip netns del physical";
      };
    };
    wg0 = {
      description = "Wireguard interface, and vpn";
      requires = [ "physical-netns.service" ];
      after = [ "physical-netns.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeScript "wgup" ''
          #! ${pkgs.bash}/bin/bash

          ${pkgs.iproute}/bin/ip -n physical link add wgvpn0 type wireguard
          ${pkgs.iproute}/bin/ip -n physical link set wgvpn0 netns 1

          ${pkgs.wireguard}/bin/wg set wgvpn0 \
            private-key /root/wireguard-keys/private \
            peer ghK62ZFGd9zkRPfF6JehK7OMAW6HMdy68RNalq9FVUo= \
            allowed-ips 0.0.0.0/0 \
            endpoint thufir:51820
          ${pkgs.iproute}/bin/ip link set wgvpn0 up

          ${pkgs.iproute}/bin/ip addr add 10.100.0.2/24 dev wgvpn0
          ${pkgs.iproute}/bin/ip route add default dev wgvpn0

          ${pkgs.iproute}/bin/ip link set enp0s25 netns physical
          ${pkgs.iw}/bin/iw phy phy0 set netns name physical

          ${pkgs.systemd}/bin/systemctl restart --no-block wpa_supplicant dhcpcd
        '';
        ExecStop =  pkgs.writeScript "wgdown" ''
          #! ${pkgs.bash}/bin/bash

          ${pkgs.iproute}/bin/ip -n physical link set enp0s25 netns 1
          ${pkgs.iproute}/bin/ip netns exec physical ${pkgs.iw}/bin/iw phy phy0 set netns 1

          ${pkgs.iproute}/bin/ip link del wgvpn0

          ${pkgs.systemd}/bin/systemctl restart --no-block wpa_supplicant dhcpcd
        '';
      };
    };

  };
}
