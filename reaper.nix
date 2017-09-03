pkgs :
let steam-run = (pkgs.steam.override { nativeOnly = true; newStdcpp = true; }).run;
    libSwell = pkgs.stdenv.mkDerivation rec {
      name = "libSwell";
      src = pkgs.fetchFromGitHub {
        owner = "justinfrankel";
        repo = "WDL";
        rev = "5ece71b296ac0282487b927774ca3246f749d9a1";
        sha256 = "1y515a3bifsn4l6si02ach0r6kdfc6gxpx8m0dnk6azhpiwjxfks";
      };

      buildInputs = [ pkgs.pkgconfig pkgs.gtk3 pkgs.xorg.libX11 ];

      buildPhase = ''
        cd WDL/swell
        make
      '';

      installPhase = ''
        mkdir -p $out/lib
        cp libSwell.so $out/lib/
      '';

      postFixup = ''
        CURRENT_RPATH=$(${pkgs.patchelf}/bin/patchelf --print-rpath $out/lib/libSwell.so)
        ${pkgs.patchelf}/bin/patchelf --set-rpath "${pkgs.xorg.libX11}/lib:$CURRENT_RPATH" $out/lib/libSwell.so
      '';
    };
    reaper = pkgs.stdenv.mkDerivation rec {
      name = "reaper";
      version = "550rc6";
      src = pkgs.fetchurl {
        url = "http://www.landoleet.org/dev/reaper_${version}_developer_linux_x86_64.tar.xz";
        sha256 = "0i2bp6g5vl8lqy4qrmyv4947vmpamglc1zw1vlkbdixb3ljyn6xl";
      };

      buildPhase = ''
        rm REAPER/libSwell.so
        ln -s ${libSwell}/lib/libSwell.so REAPER/
      '';

      installPhase = ''
        mkdir -p $out
        cp -r . $out
        mkdir $out/bin
        cat > $out/bin/reaper <<END
        ${steam-run}/bin/steam-run $out/REAPER/reaper5
        END
        chmod +x $out/bin/reaper
      '';

      postFixup = ''
        ${pkgs.patchelf}/bin/patchelf \
          --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 \
          --set-rpath "${pkgs.libjack2}/lib:${pkgs.stdenv.cc.cc.lib}/lib" \
          $out/REAPER/reaper5
      '';
    };
in reaper
