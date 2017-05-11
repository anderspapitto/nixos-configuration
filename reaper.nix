pkgs :
let steam-run = (pkgs.steam.override { nativeOnly = true; newStdcpp = true; }).run;
    libSwell = pkgs.stdenv.mkDerivation rec {
      name = "libSwell";
      src = pkgs.fetchFromGitHub {
        owner = "justinfrankel";
        repo = "WDL";
        rev = "9470b9c44d7e6fbfb3316c385891cedb66203199";
        sha256 = "1nm9v4gnmy966byahzxq25h4fa8a42dp0b6hd675i2nl6f822b24";
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
      version = "540";
      src = pkgs.fetchurl {
        url = "http://www.landoleet.org/dev/reaper_${version}_developer_linux_x86_64.tar.xz";
        sha256 = "1v8qyxxms0dm8ldvxb6xn6bnzkvc654bpilawrlbsmisvmj3mkmm";
      };

      buildPhase = ''
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
