# taken from https://github.com/Ericson2314/nixos-configuration/blob/nixos/user/.nixpkgs/rust-nightly.nix

{ config, pkgs, ... }:

let date = "2016-05-15";
    ericson-config = pkgs.fetchFromGitHub {
      owner = "Ericson2314";
      repo = "nixos-configuration";
      rev = "7a4fd62e381a86bc7af83995551feded3b15bc18";
      sha256 = "0czqdbw114wyr2430515y9q82n8yzvx604n0qwqh29f8pvkdyz0m";
    };
    ericson-helper = pkgs.callPackage "${ericson-config}/user/.nixpkgs/rust-nightly.nix" { };
    rustcNightly = ericson-helper.rustc {
        inherit date;
        hash = "1672nl4fdvvdhbw1syij6cvxcs8k7kbbi72h69v3d0jmwfksh4h9";
    };
    cargoNightly = ericson-helper.cargo {
        inherit date;
        hash = "042sa2ngy8h2wjw5clc16qbdl58kx9mi2pfyk2x5kgn67sbqi064";
    };
    sourceNightly = pkgs.fetchurl {
        url = "https://static.rust-lang.org/dist/${date}/rustc-nightly-src.tar.gz";
        sha256 = "1072y303fkhvpvrdjcgii1v2ckvxpxval6wkd6rnlnc5wvdfkava";
    };
    rustPlatformNightly = pkgs.recurseIntoAttrs (pkgs.makeRustPlatform (cargoNightly // { rustc = rustcNightly; }) rustPlatformNightly);
    racerNightly  =  pkgs.racerRust.override { rustPlatform = rustPlatformNightly; };
    racerdNightly = pkgs.racerdRust.override { rustPlatform = rustPlatformNightly; };
# in { environment.systemPackages = [ rustcNightly cargoNightly racerNightly racerdNightly ]; }
in { environment.systemPackages = with pkgs; [ rustc cargo racerRust racerdRust ]; }
