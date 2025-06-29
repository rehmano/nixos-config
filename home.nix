{ pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rehmans";
  home.homeDirectory = "/home/rehmans";

  # ZSH CONFIGS
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "clean";
    };

    history.size = 10000;
  };

  # DIRENV CONFIGS
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # OBS
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  # EDITOR
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula";
      editor = {
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "hint";
        };
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
    ];
  };

  programs.mpv = {
    enable = true;
  };

  home.packages = with pkgs; [
    spotify
    mattermost-desktop
    discord
    (bolt-launcher.override { enableRS3 = true; })
    qbittorrent
    dolphin-emu
    prismlauncher
    vscode
    nixd
    nil
    heroic
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
}
