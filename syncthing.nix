{ user, dataDir }:
{ config, pkgs, ... }:

let syncthing-source = pkgs.stdenv.mkDerivation rec {
      name = "syncthing-source";
      version = "0.13.4";

      src = pkgs.fetchurl {
        url = "https://github.com/syncthing/syncthing/releases/download/v${version}/syncthing-source-v${version}.tar.gz";
        sha256 = "0yx6bjis41vrkgm9p9zfczbq8s2ldahgl7xh25l6y5pq03z17q8r";
      };

      phases = "unpackPhase buildPhase";

      buildInputs = [ pkgs.go ];

      unpackPhase = "
        mkdir -p $out/gopath/src/github.com/syncthing
        cd $out/gopath/src/github.com/syncthing
        tar xf ${src}
      ";

      buildPhase = ''
        cd $out/gopath/src/github.com/syncthing/syncthing
        export GO15VENDOREXPERIMENT=1
        export GOPATH=$out/gopath
        ${pkgs.go}/bin/go run build.go -no-upgrade tar
        mv $out/gopath/src/github.com/syncthing/syncthing/syncthing-*-v${version}.tar.gz $out/syncthing.tar.gz
        rm -rf $out/gopath
      '';
    };

    syncthing-latest = pkgs.stdenv.mkDerivation rec {
      name = "syncthing-latest";
      src = syncthing-source;

      installPhase = ''
        mkdir -p $out
        cd $out
        tar xf ${syncthing-source}/syncthing.tar.gz

        dir=`echo syncthing-*-v${syncthing-source.version}-noupgrade`
        echo $dir

        mv syncthing-*-v${syncthing-source.version}-noupgrade/* .
        rmdir syncthing-*-v${syncthing-source.version}-noupgrade/

        mkdir bin
        mv syncthing bin
      '';
    };
in {
   networking.firewall = {
    allowedUDPPorts = [ 21027 ];
    allowedTCPPorts = [ 22000 ];
  };
  services.syncthing = {
    enable = true;
    package = syncthing-latest;
    inherit user dataDir;
  };
}
