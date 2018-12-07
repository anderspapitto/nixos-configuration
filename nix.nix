{ config, pkgs, ... }:

{ nix = {
    buildCores = 0;
    daemonIONiceLevel = 4;
    daemonNiceLevel = 10;
    maxJobs = 8;
    extraOptions = ''
        auto-optimise-store = true
        gc-keep-outputs = true
      '';
    nixPath = [
        "/etc/nixos"
        "nixos-config=/etc/nixos/configuration"
      ];
    useSandbox = true;
    binaryCaches = [
      "https://cache.nixos.org"
      "https://nixcache.reflex-frp.org"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
  };
}
