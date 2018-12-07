{ config, pkgs, ... }:

{ environment.systemPackages = with pkgs; [
    (python3.buildEnv.override { extraLibs = [ python3Packages.ipython ]; })
    (haskellPackages.ghcWithPackages (p: with p; [ turtle ]))
    # android-studio
    aspell
    aria2
    awscli
    cmake
    # coq
    gcc
    gdb
    go
    gnumake
    ispell
    jq
    patchelf
    sqlite
    valgrind
    vscode
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
        [core]
          excludesfile = /etc/gitignore
      '';
    gitignore.text = ''
        *.org
        *.org_archive
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
