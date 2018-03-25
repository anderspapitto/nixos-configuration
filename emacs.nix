{ config, pkgs, ... }:

let
  emacs = pkgs.emacs25;
  terminal = pkgs.writeScriptBin "anders-terminal" ''
    ${emacs}/bin/emacsclient -c -e '(anders/get-term)'
  '';
  editor = pkgs.writeScriptBin "anders-editor" ''
    ${emacs}/bin/emacsclient -c
  '';
  capture = pkgs.writeScriptBin "anders-capture" ''
    ${emacs}/bin/emacsclient -c -e '(org-capture nil "t")'
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
    ];
    systemPackages = [ emacs editor capture terminal ];
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
