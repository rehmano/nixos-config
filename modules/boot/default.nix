{
  pkgs,
  ...
}:

{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    style = {
      wallpapers = [
        pkgs.nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath
      ];
    };
  };
}
