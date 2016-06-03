{ config, pkgs, ... }:

let
  emacs = pkgs.emacsWithPackages
    (with pkgs.emacsPackagesNg; [
      ag
      async
      cargo
      calfw
      clojure-mode
      company
      flycheck
      flycheck-rust
      git-commit
#      git-rebase
      go-mode
      ghc-mod
      haskell-mode
      helm
      helm-descbinds
      helm-nixos-options
      helm-projectile
      magit
      magit-popup
      markdown-mode
      multiple-cursors
      nixos-options
      org-gcal
      projectile
      rainbow-delimiters
      real-auto-save
      rtags
      rust-mode
      undo-tree
      web-mode
    ]);
  startEmacsServer = pkgs.writeScript "start-emacs-server"
    ''
      #!${pkgs.bash}/bin/bash
      . ${config.system.build.setEnvironment}
      exec ${emacs}/bin/emacs --daemon
    '';
in {
  environment.systemPackages = [ emacs ];
  systemd.user.services.emacs = {
    description = "Emacs: the extensible, self-documenting text editor";
    environment = {
      GTK_DATA_PREFIX = config.system.path;
      SSH_AUTH_SOCK = "%t/ssh-agent";
      GTK_PATH = "${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0";
    };
    serviceConfig = {
      Type = "forking";
      ExecStart = "${startEmacsServer}";
      ExecStop = "${emacs}/bin/emacsclient --eval (kill-emacs)";
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
  };
}
