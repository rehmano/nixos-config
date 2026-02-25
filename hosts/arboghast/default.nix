{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/common
    ../../modules/development
    ../../modules/gaming
    ../../modules/plasma
    ../../users/rehmans
  ];

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "peach";

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
    flake = "/home/rehmans/nixos";
  };
}
