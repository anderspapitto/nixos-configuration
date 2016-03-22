{ config, pkgs, ... }:

{ containers.overtone = {
    bindMounts = [ { hostPath   = "/home/anders/devel/insane-noises";
                     mountPoint = "/home/anders/devel/insane-noises";
                     isReadOnly = false;
                   }
                 ];
    config =
      { config, pkgs, ... }:
      { users.extraUsers.anders = {
          isNormalUser = true;
          uid = 1000;
          extraGroups = [ "wheel" ];
        };

        users.users.anders.openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt6axfh25SwAPkrTQlIJKqZkQ2zxxI6/a45Oa2uGclh2qjpic4egy4zQbHXCJOM8Baz9xfzmJDxWAhwckiiXYvG6W5bignIfx8F/z8P27Jganv9Np5GptG2E0tZKoSFXkCN7B3H4+/r4O6eWsx9mM8NzABIP6i+vqZ/5gaW1PUGBWX4yZRVKr9WbTGJp4R6txvW6aPaJKGOGqFCDqU9SzWC8uZFWOxcIMI/2gn0eW27cCL/ro1i4DDVMQsDnDqxJ6cHIKzNsQcGSGN8q67zPMFdxlrZ+9xnATkQxyRXuuU5xArusY+acWGUBa3lixfYTD9XFcgddctG3x6xwSHN9zx anders@gurney"
        ];

        services = {
          openssh = {
            enable = true;
            permitRootLogin = "yes";
          };
          dnsmasq.enable = true;
        };

        networking = {
          dhcpcd.extraConfig = ''
            nohook resolv.conf
            noipv4ll
          '';
          nameservers = [ "192.168.100.10" "8.8.8.8" "8.8.4.4" ];
        };

        systemd.mounts = [
          { options = "bind";
            what = "/run/current-system/sw/bin";
            where = "/bin";
            wantedBy = [ "default.target" ];
          }
        ];

        environment = {
          systemPackages = with pkgs; [
            leiningen
            avahi
            libsndfile
            libjack2
            gcc
            fftwSinglePrec
            x11
          ];
          variables = {
            LD_LIBRARY_PATH = "/run/current-system/sw/lib";
          };
        };
      };

    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.12";
  };
}
