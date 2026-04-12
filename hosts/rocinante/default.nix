# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/common
    ../../modules/development
    ../../modules/docker
    ../../modules/gaming
    ../../modules/plasma
    ../../modules/vpn
    ../../users/rehmans
  ];

  # Module options
  gaming.enable = true;
  gaming.openSteamPorts = true;

  boot.kernelPackages = pkgs.linuxPackages;
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  programs.nh = {
    flake = "/home/rehmans/nixos";
  };

  hardware = {
    bluetooth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 48 * 1024;
    }
  ];
}
