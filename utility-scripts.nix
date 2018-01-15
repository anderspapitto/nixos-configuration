{ config, pkgs, ... }:

let utility-scripts-src = pkgs.fetchFromGitHub {
      owner = "anderspapitto";
      repo = "utility-scripts";
      rev = "381f24ed1554561c929f96856b0c1e6c7cf4116c";
      sha256 = "042s7bwm1jff195ilz2wmhrarlz2ia63m9biinhb2wlg7rjb82ay";
    };
in {
    environment.systemPackages = [
      (pkgs.callPackage "${utility-scripts-src}/nix-shell-wrapper" { })
      (pkgs.callPackage "${utility-scripts-src}/i3-focus" { })
    ];
}
