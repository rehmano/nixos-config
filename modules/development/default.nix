{ config, pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.git.enable = true;
  environment.systemPackages = [
    pkgs.tldr
    pkgs.curl
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.nixfmt
    pkgs.nixfmt-tree
    pkgs.wget
    pkgs.htop
  ];
}
