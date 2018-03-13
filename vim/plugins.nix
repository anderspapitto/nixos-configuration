{ pkgs, fetchFromGitHub, fetchgit,
  python3, stdenv, cmake, boost, icu, readline
}:

let
  buildVimPluginFrom2Nix = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {
  vim-addon-manager = pkgs.vimPlugins.vim-addon-manager;
  vim2nix = pkgs.vimPlugins.vim2nix;

  vim-nix = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-nix-2018-02-25";
    src = fetchgit {
      url = "https://github.com/LnL7/vim-nix";
      rev = "36c5feb514930e8fb8e2f4567d6b0d9e806fc2eb";
      sha256 = "1v0vm0h5j6zzwhm5gw3xcmckswma3a5kxyli34i8hy14yli0ff3d";
    };
    dependencies = [];

  };

  deoplete-nvim = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "deoplete-nvim-2018-03-12";
    src = fetchgit {
      url = "https://github.com/Shougo/deoplete.nvim";
      rev = "c3c9406bfb4207c057d6a366c88466256a6ea2bd";
      sha256 = "13ks62da4lrcwcy3ip95nzyfvadfcjrww7c9n5322nibqqgcbda5";
    };
    dependencies = [];

  };

  vim-gitgutter = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-gitgutter-2018-03-08";
    src = fetchgit {
      url = "https://github.com/airblade/vim-gitgutter";
      rev = "380e7935b7b4cac10d3bc3031d492deaf5008495";
      sha256 = "0c1dh3rkhgrp1sala1y5y2wn7b94c75y7h3j3dsl8lmbl64y2vl8";
    };
    dependencies = [];

  };

  vim-rooter = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-rooter-2017-11-20";
    src = fetchgit {
      url = "https://github.com/airblade/vim-rooter";
      rev = "3509dfb80d0076270a04049548738daeedf6dfb9";
      sha256 = "03j26fw0dcvcc81fn8hx1prdwlgnd3g340pbxrzgbgxxq5kr0bwl";
    };
    dependencies = [];

  };

  vim-colors-solarized = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-colors-solarized-2011-05-09";
    src = fetchgit {
      url = "https://github.com/altercation/vim-colors-solarized";
      rev = "528a59f26d12278698bb946f8fb82a63711eec21";
      sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
    };
    dependencies = [];

  };

  vim-freemarker = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-freemarker-2017-07-08";
    src = fetchgit {
      url = "https://github.com/andreshazard/vim-freemarker";
      rev = "993bda23e72e4c074659970c1e777cb19d8cf93e";
      sha256 = "1dixs9dbsn6k96x315dysrkmd8d6v0g9nn8nmvsf3i7as6xag0c3";
    };
    dependencies = [];

  };

  ctrlp-vim = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "ctrlp-vim-2018-02-10";
    src = fetchgit {
      url = "https://github.com/ctrlpvim/ctrlp.vim";
      rev = "35c9b961c916e4370f97cb74a0ba57435a3dbc25";
      sha256 = "08g1w7lfxpp0b175fkyyb8njpz7jwysfba0s20873f2frj6c77rc";
    };
    dependencies = [];

  };

  jedi-vim = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "jedi-vim-2018-02-16";
    src = fetchgit {
      url = "https://github.com/davidhalter/jedi-vim";
      rev = "48af2afd3ef06a61242d5c08a6357879ea639c36";
      sha256 = "0sin4kp4jpazr0d624rbhknngizwb1bl19bwvbj9hxl0vn6ipxa2";
    };
    dependencies = [];

  };

  vim-easymotion = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-easymotion-2017-10-20";
    src = fetchgit {
      url = "https://github.com/easymotion/vim-easymotion";
      rev = "342549e7a1e5b07a030803e0e4b6f0415aa51275";
      sha256 = "1glv4s95v8xxj47n0jzjxd0pxphnnpgzyd384d2bh0ql1xgf320v";
    };
    dependencies = [];

  };

  vim-go = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-go-2018-03-07";
    src = fetchgit {
      url = "https://github.com/fatih/vim-go";
      rev = "d2b0a234ffb5441a3488c78fe8e5f551ddbdd454";
      sha256 = "1qcy1w9p23gxrii4ddg6mn8kn4i9d0q3rmkrblvxhbk7snxbh7n8";
    };
    dependencies = [];

  };

  vim-terraform = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-terraform-2018-03-09";
    src = fetchgit {
      url = "https://github.com/hashivim/vim-terraform";
      rev = "76799270813db362b13a56f26cd34f668e9e17a4";
      sha256 = "0j3cnnvhs41phz0kiyaprp05vxhf5jaaw5sn5jcn08yc6jhy009r";
    };
    dependencies = [];

  };

  python-syntax = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "python-syntax-2015-11-01";
    src = fetchgit {
      url = "https://github.com/hdima/python-syntax";
      rev = "69760cb3accce488cc072772ca918ac2cbf384ba";
      sha256 = "1ix7li8sjcn3i3g9jm2jng1gkjqh8r11qccfdblkjv7wxxzwpg01";
    };
    dependencies = [];

  };

  nrun-vim = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "nrun-vim-2017-10-19";
    src = fetchgit {
      url = "https://github.com/jaawerth/nrun.vim";
      rev = "847dd4887eded123314896caf50b1c9a8502e599";
      sha256 = "1cqpkd2czj9llx27psnn5zi9q874lv1bdsmq14f4rmrhi2kwmmqh";
    };
    dependencies = [];

  };

  tagbar = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "tagbar-2017-12-17";
    src = fetchgit {
      url = "https://github.com/majutsushi/tagbar";
      rev = "387bbadda98e1376ff3871aa461b1f0abd4ece70";
      sha256 = "0srmslg0v1a7zhzz0wgzgv7jyr0j3q9m766qzb7zimkkb32fcbx9";
    };
    dependencies = [];

  };

  undotree = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "undotree-2017-10-26";
    src = fetchgit {
      url = "https://github.com/mbbill/undotree";
      rev = "cdbb9022b8972d3e156b8d60af33bf795625b058";
      sha256 = "0y62hp8k2kbrq0jhxj850f706rqjv2dkd7dxhz458mrsdk60f253";
    };
    dependencies = [];

  };

  vim-grepper = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-grepper-2018-03-06";
    src = fetchgit {
      url = "https://github.com/mhinz/vim-grepper";
      rev = "46d78f293b12d8ba743f68ce4fb69881a64d30b2";
      sha256 = "19pbsv8i58r2z5a2yvn8f8v7gjz82nn8mw0hhfzwg5nlj0nn5kx3";
    };
    dependencies = [];

  };

  vim-jsx = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-jsx-2018-02-19";
    src = fetchgit {
      url = "https://github.com/mxw/vim-jsx";
      rev = "52ee8bb9f4b53e9bcb38c95f9839ec983bcf7f9d";
      sha256 = "0widi2gnxvdfzhhn0digcjqb28npxv0dpm3l37ijklcfxbc16hzi";
    };
    dependencies = [];

  };

  cpsm = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "cpsm-2018-02-01";
    src = fetchgit {
      url = "https://github.com/nixprime/cpsm";
      rev = "8a4a0a05162762b857b656d51b59a5bf01850877";
      sha256 = "0v44gf9ygrqc6rpfpiq329jija4icy0iy240yk30c0r04mjahc0b";
    };
    dependencies = [];
    buildInputs = [
      python3
      stdenv
      cmake
      boost
      icu
    ];
    buildPhase = ''
      patchShebangs .
      export PY3=ON
      ./install.sh
    '';
  };

  vim-javascript = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-javascript-2018-03-04";
    src = fetchgit {
      url = "https://github.com/pangloss/vim-javascript";
      rev = "3e0b1af8c2b2b613add52d782b29f325c6a414e3";
      sha256 = "1rxds6sswnm7xyy39ljwhykb3r6jd9jsm1lbhhw2r226d56pj15w";
    };
    dependencies = [];

  };

  vim-reason = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-reason-2017-11-06";
    src = fetchgit {
      url = "https://github.com/reasonml-editor/vim-reason";
      rev = "d8f0885979d7b1053e57bb36bb5311c9177d9f5c";
      sha256 = "0qqz03167hxff69favp9vwf05mn0kfqxps2qzkfdkjpq6ffkavia";
    };
    dependencies = [];

  };

  nerdtree = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "nerdtree-2018-03-06";
    src = fetchgit {
      url = "https://github.com/scrooloose/nerdtree";
      rev = "ed446e5cbe0733a8f98befc88d33e42edebb67d2";
      sha256 = "0i5qy8lb8w5ri30905i7411754g2vzj4jlccak5lj852vyzgdp56";
    };
    dependencies = [];

  };

  vim-delve = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-delve-2018-02-26";
    src = fetchgit {
      url = "https://github.com/sebdah/vim-delve";
      rev = "2f2a61e3649bc63a53a50f17e23b265e666c5a16";
      sha256 = "15wz19ar2agnkiznawywfps3ia8syv7c2c9f0h5ycd2r1bij1l8s";
    };
    dependencies = [];

  };

  vim-multiple-cursors = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-multiple-cursors-2018-03-02";
    src = fetchgit {
      url = "https://github.com/terryma/vim-multiple-cursors";
      rev = "c9b95e49a48937903c9fc41d87d9b4c9aded10d7";
      sha256 = "1r8xlfydarvaags541xn1mc5ry97ikyvjhkrpyngzfw48jlc0aaa";
    };
    dependencies = [];

  };

  vim-fugitive = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-fugitive-2018-01-25";
    src = fetchgit {
      url = "https://github.com/tpope/vim-fugitive";
      rev = "b82abd5bd583cfb90be63ae12adc36a84577bd45";
      sha256 = "0y3fkw7f5gqb339qlby19f444085c929gjbmbibmgig7hrarqrz4";
    };
    dependencies = [];

  };

  vim-airline = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-airline-2018-03-06";
    src = fetchgit {
      url = "https://github.com/vim-airline/vim-airline";
      rev = "958f78335eafe419ee002ad58d358854323de33a";
      sha256 = "1h0a0rsnbbwhw55r2hcpfkxqamnx62jzqb451lh3ipvfs0ral6w7";
    };
    dependencies = [];

  };

  vim-airline-themes = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-airline-themes-2018-01-05";
    src = fetchgit {
      url = "https://github.com/vim-airline/vim-airline-themes";
      rev = "4b7f77e770a2165726072a2b6f109f2457783080";
      sha256 = "02wbch9mbj0slafd5jrklmyawrxpisf8c3f5c72gq30j8hlyb86n";
    };
    dependencies = [];

  };

  vimoutliner = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vimoutliner-2018-02-17";
    src = fetchgit {
      url = "https://github.com/vimoutliner/vimoutliner";
      rev = "ec4dc9bd932a0cce476a3f8f0a78ca61ff94188c";
      sha256 = "0fj3ya7n9wfbnkcdwp9kggm8c3p5jm3iwzbk4gdqjmhqkvdfz5rk";
    };
    dependencies = [];

  };

  ale = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "ale-2018-03-10";
    src = fetchgit {
      url = "https://github.com/w0rp/ale";
      rev = "05d39bc1a9eb79ff6f36b190b4612ff052812e7e";
      sha256 = "0p8pllh93bd43051rjcw9jamkmldb0rc3x8llw010m05jgrkngda";
    };
    dependencies = [];

  };

  vim-easytags = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-easytags-2015-07-01";
    src = fetchgit {
      url = "https://github.com/xolox/vim-easytags";
      rev = "72a8753b5d0a951e547c51b13633f680a95b5483";
      sha256 = "0i8ha1fa5d860b1mi0xp8kwsgb0b9vbzcg1bldzv6s5xd9yyi12i";
    };
    dependencies = ["vim-misc"];

  };

  deoplete-go = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "deoplete-go-2018-02-04";
    src = fetchgit {
      url = "https://github.com/zchee/deoplete-go";
      rev = "513ae17f1bd33954da80059a21c128a315726a81";
      sha256 = "0rfxzryccrq3dnjgb9aljzrmfjk7p8l2qdjkl8ar4bh2hmz8vn5y";
    };
    dependencies = [];
    buildInputs = [ python3 ]; 
    buildPhase = ''
      pushd ./rplugin/python3/deoplete/ujson
      python3 setup.py build --build-base=$PWD/build --build-lib=$PWD/build
      popd
      find ./rplugin/ -name "ujson*.so" -exec mv -v {} ./rplugin/python3/ \;
    '';
  };

  deoplete-jedi = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "deoplete-jedi-2018-01-26";
    src = fetchgit {
      url = "https://github.com/zchee/deoplete-jedi";
      rev = "f7a0c4ffc53c16a931f761819240f60eafec9604";
      sha256 = "1i1hxvqff8c0n8gasfq97aszchh6709w4s1qj1h809ikaqdil7xr";
    };
    dependencies = [];

  };

  vim-misc = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-misc-2015-05-21";
    src = fetchgit {
      url = "git://github.com/xolox/vim-misc";
      rev = "3e6b8fb6f03f13434543ce1f5d24f6a5d3f34f0b";
      sha256 = "0rd9788dyfc58py50xbiaz5j7nphyvf3rpp3yal7yq2dhf0awwfi";
    };
    dependencies = [];

  };
}
