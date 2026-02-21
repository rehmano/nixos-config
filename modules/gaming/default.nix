{
  pkgs,
  ...
}:

{
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };

  programs.gamescope.enable = true;

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
    dolphin-emu
  ];

  hardware = {
    steam-hardware.enable = true;
    xone.enable = true;
    uinput.enable = true;
  };

  environment.systemPackages = [
    pkgs.protonup-qt
    pkgs.mangohud
    (pkgs.heroic.override {
      extraPkgs =
        pkgs': with pkgs'; [
          gamescope
        ];
    })
    pkgs.r2modman
    pkgs.dolphin-emu
    pkgs.openrct2
    (import ../../pkgs/soh.nix { inherit pkgs; })
  ];

  programs.steam = {
    enable = true;
    # Host needs to define this
    # remotePlay.openFirewall; localNetworkGameTransfers.openFirewall;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  services.lact.enable = true;
}
