{ config, pkgs, ... }:

let utility-scripts-src = pkgs.fetchFromGitHub {
      owner = "anderspapitto";
      repo = "utility-scripts";
      rev = "4501836598b5367227167624f09bdb8b3d24c6ac";
      sha256 = "1zq1rixxrrdk87ab2m92ai9ndibxps1dk3pm25rsfx218287z56m";
    };
in {
    environment.systemPackages = [
      (pkgs.callPackage "${utility-scripts-src}/nix-shell-wrapper" { })
    ];
}
