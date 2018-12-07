{ config, pkgs, ... }:

let
  emacs = pkgs.emacs;
  terminal = pkgs.writeScriptBin "anders-terminal" ''
    ${emacs}/bin/emacsclient -c -a=""
  '';
  editor = pkgs.writeScriptBin "anders-editor" ''
    ${emacs}/bin/emacsclient -c -a=""
  '';
  capture = pkgs.writeScriptBin "anders-capture" ''
    ${emacs}/bin/emacsclient -c -a="" -e '(org-capture nil "t")'
  '';
in {
  environment.systemPackages = [ emacs editor capture terminal ];
}
