{ config, pkgs, ... }:

{ nix = {
    trustedBinaryCaches = [  "https://nixcache.reflex-frp.org" "https://hydra.cryp.to" ];
    binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

    buildCores = 0;
    daemonIONiceLevel = 4;
    daemonNiceLevel = 10;
    maxJobs = 8;
    extraOptions = ''
      auto-optimise-store = true
    '';
    nixPath = [ "/etc/nixos" "nixos-config=/etc/nixos/configuration" ];
    useChroot = true;

  };

  system.stateVersion = "16.03";
}
