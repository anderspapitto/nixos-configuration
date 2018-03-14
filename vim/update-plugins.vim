let opts = {}
let opts.path_to_nixpkgs = '/etc/nixos/nixpkgs'
let opts.cache_file = '/tmp/update-vim-plugins-cache'
let opts.plugin_dictionaries = map(readfile("vim-plugins"), 'eval(v:val)')
call nix#ExportPluginsForNix(opts)
