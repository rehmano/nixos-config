{ config, pkgs, ... }:

{
  programs.nix-ld.enable = true;
  environment.systemPackages = [
    pkgs.curl
    pkgs.nixfmt
    pkgs.nixfmt-tree
    pkgs.wget
    pkgs.htop
  ];
}
