{ config, pkgs, ... }:

let utility-scripts-src = pkgs.fetchFromGitHub {
      owner = "anderspapitto";
      repo = "utility-scripts";
      rev = "9c56f2ebb60329ff108d9a9606423fc410635c6e";
      sha256 = "0lsbw3ywirgk6gdmprqfjgf10418s8dz7a9agg6l0kaf0l0kf1zg";
    };
in {
    environment.systemPackages = [
      (pkgs.callPackage "${utility-scripts-src}/nix-shell-wrapper" { })
      (pkgs.callPackage "${utility-scripts-src}/i3-focus" { })
    ];
}
