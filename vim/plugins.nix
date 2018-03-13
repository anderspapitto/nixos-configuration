{ pkgs, fetchFromGitHub, fetchgit,
  python3, stdenv, cmake, boost, icu, readline
}:

let
  buildVimPluginFrom2Nix = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {
  vim-addon-manager = pkgs.vimPlugins.vim-addon-manager;
  vim2nix = pkgs.vimPlugins.vim2nix;

  vim-nix = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-nix-2017-04-30";
    src = fetchgit {
      url = "https://github.com/LnL7/vim-nix";
      rev = "867488a04c2ddc47f0f235f37599a06472fea299";
      sha256 = "1mwc06z9q45cigyxd0r9qnfs4ph6lbcwx50rf5lmpavakcn3vqir";
    };
    dependencies = [];

  };

  deoplete-nvim = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "deoplete-nvim-2018-02-22";
    src = fetchgit {
      url = "https://github.com/Shougo/deoplete.nvim";
      rev = "51cfc342e10eeba1c32e455a4205a3346da6fc29";
      sha256 = "0h1222vmgif786jp8590bn54ywm2lalq827m2hld8kch31s4qhmq";
    };
    dependencies = [];

  };

  vim-gitgutter = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-gitgutter-2018-02-22";
    src = fetchgit {
      url = "https://github.com/airblade/vim-gitgutter";
      rev = "b27ee4d602d7ce6f7b7caf8e9ecb8eded57ffe0a";
      sha256 = "09q2mj3ryprinh36gc7gxa0vnwypdhkc4x7zjsx8ppzpckfdy8sn";
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

  vim-go = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-go-2018-02-08";
    src = fetchgit {
      url = "https://github.com/fatih/vim-go";
      rev = "cc0467c3c567b9e95a694f160f2d5cd1cd21dad4";
      sha256 = "1l6jzjr46wrwdg0i0d3janq3bwcb07dqk2d2ykby15mlwl2w55cp";
    };
    dependencies = [];

  };

  vim-terraform = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-terraform-2018-01-23";
    src = fetchgit {
      url = "https://github.com/hashivim/vim-terraform";
      rev = "33c0631028a2c3e20f634bc9cffcf3e4175126c2";
      sha256 = "16hblij2dx03y8fvxpjcygvsmgkfdipr2c8dpgh9rwxkfvcc2sja";
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
    name = "vim-grepper-2018-02-22";
    src = fetchgit {
      url = "https://github.com/mhinz/vim-grepper";
      rev = "58a808c0628fd88ba8e483931cd83da14e9b050a";
      sha256 = "1dk0zpypp4aj6w22bl7cjd1k0rk0cxr433h2dfiz7ryv7nnv3d9a";
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
      readline
    ];
    buildPhase = ''
      patchShebangs .
      export PY3=ON
      ./install.sh
    '';
  };

  vim-javascript = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-javascript-2018-02-15";
    src = fetchgit {
      url = "https://github.com/pangloss/vim-javascript";
      rev = "89fcb6bfcada1c4256284723778d128342b48350";
      sha256 = "0pml413qa9ydjcg06hzamkc5zvd76zdx0wffvkwgr1z1srykd4sh";
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
    name = "nerdtree-2018-02-02";
    src = fetchgit {
      url = "https://github.com/scrooloose/nerdtree";
      rev = "e47e588705bd7d205a3b5a60ac7090c9a2504ba2";
      sha256 = "15ai00k7w0brbjvmsj920hpnqy4iz1y3b0pw04m3mlcx20pkfy9s";
    };
    dependencies = [];

  };

  vim-delve = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-delve-2017-12-01";
    src = fetchgit {
      url = "https://github.com/sebdah/vim-delve";
      rev = "386a25aba597f214f862a3f0a693ccf22c5f1dfd";
      sha256 = "1ajry62rmdm85qmi9aksdlhw74ckbbvg84j27ybz07687vmvxsl7";
    };
    dependencies = [];

  };

  vim-multiple-cursors = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-multiple-cursors-2018-02-19";
    src = fetchgit {
      url = "https://github.com/terryma/vim-multiple-cursors";
      rev = "b67058d3ceba79e946223244bffa5e49eb52cde5";
      sha256 = "0jicjwpr8cbl26dkvw1ls17hfnirdmlm96pzb6srg583wzqyds0m";
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
    name = "vim-airline-2018-02-14";
    src = fetchgit {
      url = "https://github.com/vim-airline/vim-airline";
      rev = "55a9721c22370a47e076e85449897ded6f45386d";
      sha256 = "1616k94g0pv6i6zva4q39d7vff3yk4vh60xni5qnliqk2g0fc281";
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
    name = "ale-2018-02-18";
    src = fetchgit {
      url = "https://github.com/w0rp/ale";
      rev = "89f8d3e456713846d1ebdd934027ae7a910cf5f8";
      sha256 = "0x4imsbs0nyvc2g792i287knhynbbjr7k1ii9zjsyx1wnzxh4wkm";
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
