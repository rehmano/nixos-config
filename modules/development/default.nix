{ config, pkgs, ... }:

{
  programs.git.enable = true;
  environment.systemPackages = [
    pkgs.tldr
  ];
}
