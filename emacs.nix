{ config, pkgs, ... }:

let
  emacs = pkgs.emacs25WithPackages
    (with pkgs.emacs25PackagesNg; [
      ace-jump-mode
      ag
      async
      cargo
      calfw
      clojure-mode
      company
      flycheck
      git-commit
#      git-rebase
      go-mode
#      ghc-mod
      haskell-mode
      helm
      helm-descbinds
#      helm-nixos-options
      helm-projectile
      magit
      magit-popup
      markdown-mode
      multiple-cursors
#      nixos-options
      org-gcal
      projectile
      rainbow-delimiters
      real-auto-save
      rtags
      shackle
      undo-tree
      web-mode

      # rust
      company-racer
      flycheck-rust
      racer
      rust-mode
    ]);
  init-el = builtins.toFile "init.el" (pkgs.lib.readFile ./config/init.el);
  my-compile-el = builtins.toFile "init.el" (pkgs.lib.readFile ./config/my-compile.el);
  startEmacsServer = pkgs.writeScript "start-emacs-server"
    ''
      #!${pkgs.bash}/bin/bash
      . ${config.system.build.setEnvironment}
      exec ${emacs}/bin/emacs --daemon -q -l ${init-el} -l ${my-compile-el}
    '';
in {
  environment.systemPackages = [ emacs ];
  systemd.services.emacs = {
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
      User = "anders";
    };
    wantedBy = [ "default.target" ];
    restartIfChanged = false;
  };
}
