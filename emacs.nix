{ config, pkgs, ... }:

let
  emacs = pkgs.emacs25;
  editor = pkgs.writeScriptBin "editor" ''
    ${emacs}/bin/emacsclient -c
  '';
  startEmacs = pkgs.writeScript "emacs" ''
      #!${pkgs.bash}/bin/bash
      . ${config.system.build.setEnvironment}
      exec ${emacs}/bin/emacs -q -l /etc/emacs/init.el "$@"
    '';
in {
  environment = {
    etc = [
      { target = "emacs/init.el";
        source = ./config/init.el;
      }
      { target = "emacs/my-compile.el";
        source = ./config/my-compile.el;
      }
      { target = "emacs/my-org.el";
        source = ./config/my-org.el;
      }
    ];
    systemPackages = [ emacs editor ];
  };
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
