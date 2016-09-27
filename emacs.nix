{ config, pkgs, ... }:

let
  emacs = pkgs.emacs25pre;
  startEmacs = pkgs.writeScript "emacs" ''
      #!${pkgs.bash}/bin/bash
      . ${config.system.build.setEnvironment}
      exec ${emacs}/bin/emacs -q -l ${init-el} -l ${my-compile-el} "$@"
    '';
  init-el = builtins.toFile "init.el" (pkgs.lib.readFile ./config/init.el);
  my-compile-el = builtins.toFile "init.el" (pkgs.lib.readFile ./config/my-compile.el);
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
      ExecStart = "${startEmacs} --daemon";
      ExecStop = "${emacs}/bin/emacsclient --eval (kill-emacs)";
      User = "anders";
    };
    wantedBy = [ "default.target" ];
    restartIfChanged = false;
  };
}
