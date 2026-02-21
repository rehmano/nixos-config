{
  config,
  lib,
  pkgs,
  ...
}:

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
        "scanner"
        "lp"
        "libvirtd"
      ]
      ++ lib.optional config.virtualisation.docker.enable "docker";
      packages = with pkgs; [
        kdePackages.ffmpegthumbs
        kdePackages.skanpage
      ];
    };
  };

  nix.settings = {
    trusted-users = [
      "rehmans"
    ];
  };
}
