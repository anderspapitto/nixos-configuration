{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import /etc/nixos/overlays/nixpkgs-mozilla/rust-overlay.nix)
  ];
  environment.systemPackages = with pkgs; [
    rustChannels.beta.rust
    (llvm.override { enableSharedLibraries = true; })
  ];
}
