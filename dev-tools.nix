{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    (python.buildEnv.override { extraLibs = [ pythonPackages.ipython ]; })
    (haskellPackages.ghcWithPackages (p: with p; [ turtle ]))
    # android-studio
    aria2
    awscli
    cmake
    # coq
    gcc
    gdb
    go
    gnumake
    jq
    nix-repl
    patchelf
    sqlite
    valgrind
    z3
  ];

  environment.etc = {
    gitconfig.text = ''
        [user]
            email = anderspapitto@gmail.com
            name = Anders Papitto
        [pull]
        	rebase = true
        [color]
        	ui = auto
        [push]
        	default = simple
        [merge]
            conflictstyle = diff3
      '';
    "stack/config.yaml".text = ''
        templates:
          params:
            author-email: anderspapitto@gmail.com
            author-name: Anders Papitto
            github-username: anderspapitto
        nix:
          enable: false
      '';
    };

  # imports = [ ./rust-overlay.nix ];
}
