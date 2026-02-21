{
  pkgs,
  ...
}:

{
  imports = [
    ../../home/firefox
    ../../home/vscode
    ../../home/zsh
  ];

  programs.mpv.enable = true;
  programs.discord.enable = true;
  programs.joplin-desktop.enable = true;

  home.packages = with pkgs; [
    spotify
    bolt-launcher
    qbittorrent
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
    })
    easyeffects
    tldr
    protonplus
    simple-scan
  ];
}
