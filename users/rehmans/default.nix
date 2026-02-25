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
      ]
      ++ lib.optional config.virtualisation.docker.enable "docker";
      packages = with pkgs; [
        kdePackages.ffmpegthumbs
      ];
    };
  };

  nix.settings = {
    trusted-users = [
      "rehmans"
    ];
  };
}
