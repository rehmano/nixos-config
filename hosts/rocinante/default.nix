{
  pkgs,
  ...
}:

{
  imports = [
    ./firewall.nix
    ./gaming.nix
    ./hardware-configuration.nix
    ./user-hardware.nix
    ../../modules/boot
    ../../modules/common
    ../../modules/desktop/plasma
    ../../modules/development
    ../../modules/docker
    ../../modules/gaming
    ../../modules/printing
    ../../modules/ssd
    ../../modules/virtualization
    ../../modules/vpn
    ../../users/rehmans
  ];
  boot.kernelPackages = pkgs.linuxPackages_cachyos-gcc;

  environment.systemPackages = [
    pkgs.nvtopPackages.amd
    pkgs.polychromatic
    pkgs.dnsmasq
    pkgs.pi-coding-agent
  ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  programs.nh = {
    flake = "/home/rehmans/nixos";
  };
}
