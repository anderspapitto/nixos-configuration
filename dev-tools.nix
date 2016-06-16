{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    (python.buildEnv.override { extraLibs = [ pythonPackages.ipython ]; })
    cabal-install
    cabal2nix
    cargo
    cmake
    gcc
    gdb
    git
    go
    gnumake
    jq
    nix-repl
    nixops
    nodePackages.coffee-script
    patchelf
    s3cmd
    stack
    sqlite
    valgrind
    z3
  ];

  imports = [ ./rust-nightly.nix ];
}
