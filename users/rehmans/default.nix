{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  users = {
    defaultUserShell = pkgs.zsh;
    users.rehmans = {
      isNormalUser = true;
      description = "Syed Rehman";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        kdePackages.kate
        kdePackages.ffmpegthumbs
      ];
    };
  };
}
