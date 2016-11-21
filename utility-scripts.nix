{ config, pkgs, ... }:

let utility-scripts-src = pkgs.fetchFromGitHub {
      owner = "anderspapitto";
      repo = "utility-scripts";
      rev = "31015d2b61cba4dca2385eb983909b4249c3dff9";
      sha256 = "1mzhl3vdi6bvhx5wr83bzqamhx7qd9a4fk1lj8h48jr2swar1vqh";
    };
in {
    environment.systemPackages = [
      (pkgs.callPackage "${utility-scripts-src}/nix-shell-wrapper" { })
      (pkgs.callPackage "${utility-scripts-src}/i3-focus" { })
    ];
}
