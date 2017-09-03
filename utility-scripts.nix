{ config, pkgs, ... }:

let utility-scripts-src = pkgs.fetchFromGitHub {
      owner = "anderspapitto";
      repo = "utility-scripts";
      rev = "96eb584a76db65a60ba51ca74df6d0c99d2cfc9a";
      sha256 = "1399f3vhnj4y2pdand81br4q50q9p205dgvy6gs7wr8zfkk2y8ky";
    };
in {
    environment.systemPackages = [
      (pkgs.callPackage "${utility-scripts-src}/nix-shell-wrapper" { })
      (pkgs.callPackage "${utility-scripts-src}/i3-focus" { })
    ];
}
