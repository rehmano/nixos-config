{ config, pkgs, ... }:

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

  networking.wireless.enable = true;
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
