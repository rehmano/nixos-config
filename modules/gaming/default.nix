{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = lib.mkEnableOption "Enables gaming suite";

    openSteamPorts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open firewall ports for remote play and local network game transfers.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.protonup-qt
      pkgs.mangohud
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = cfg.openSteamPorts;
      localNetworkGameTransfers.openFirewall = cfg.openSteamPorts;
      gamescopeSession.enable = true;
    };
  };
}
