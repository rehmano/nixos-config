# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot
    ../../modules/common
    ../../modules/development
    ../../modules/gaming
    ../../modules/plasma
    ../../modules/vpn
    ../../users/rehmans
  ];

  # Module options
  gaming.enable = true;
  gaming.openSteamPorts = true;

  # NixOS options
  hardware.amdgpu.initrd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "amd_pstate=active" ];
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
    flake = "/home/rehmans/nixos";
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
  ];

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "peach";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
