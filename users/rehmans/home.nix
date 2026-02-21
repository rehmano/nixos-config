{ pkgs, ... }:

let
  fluxerBin = pkgs.callPackage ../../pkgs/fluxer-bin.nix { };
in
{
  home.username = "rehmans";
  home.homeDirectory = "/home/rehmans";

  programs.zsh = {
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "git"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "prompt"
      ];
    };

    history.size = 20000;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  programs.mpv.enable = true;
  programs.discord.enable = true;
  programs.vscode.enable = true;
  programs.joplin-desktop.enable = true;
  programs.firefox.enable = true;

  home.packages = with pkgs; [
    spotify
    bolt-launcher
    qbittorrent
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        graalvmPackages.graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
    nixd
    nil
    heroic
    easyeffects
    devenv
    kodi-wayland
    signal-desktop
    fluxerBin
  ];
}
