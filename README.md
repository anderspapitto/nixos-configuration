nixos-configuration
===================

This is a decently modularized set of configuration files for a NixOS
system, which I mainly use to configure my laptop.

The entrypoint is `default.nix`, and the module system is used
heavily.

Private files/data are placed in a `private` subdirectory, which is
hidden via `.gitignore`.

I place this repository in `/etc/nixos`, next to my local checkout of
nixpkgs, which I use instead of the channel mechanism. A suitably
modified `NIX_PATH` allows this to work (see `nix.nix`).

```bash
[anders@gurney:/etc/nixos]
$ ls -la
total 16
drwxr-xr-x  4 root   root  4096 Mar 21 22:30 .
drwxr-xr-x 23 root   root  4096 Mar 21 22:31 ..
drwxr-xr-x  6 anders users 4096 Mar 21 22:34 configuration
drwxrwxr-x  9 anders users 4096 Mar 21 19:31 nixpkgs
[anders@gurney:/etc/nixos]
$ echo $NIX_PATH
/etc/nixos:nixos-config=/etc/nixos/configuration
```
