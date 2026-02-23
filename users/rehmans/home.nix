{
  self,
  hostname,
  pkgs,
  ...
}:

let
  fluxerBin = pkgs.callPackage ../../pkgs/fluxer-bin.nix { };
in
{
  home.username = "rehmans";
  home.homeDirectory = "/home/rehmans";

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "peach";

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
    autosuggestion.enable = true;
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

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    profiles = {
      default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          mkhl.direnv
          jnoortheen.nix-ide
          usernamehw.errorlens
        ];
        userSettings = {
          "telemetry.telemetryLevel" = "off";
          "telemetry.feedback.enabled" = false;
          "telemetry.editStats.enabled" = false;
          "workbench.editor.enablePreview" = false;
          "extensions.ignoreRecommendations" = true;
          "files.autoSave" = "afterDelay";
          "editor.formatOnSave" = true;
          "workbench.commandPalette.showAskInChat" = false;
          "workbench.settings.showAISearchToggle" = false;
          "chat.disableAIFeatures" = true;
          "direnv.restart.automatic" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [
                  "nixfmt"
                ];
              };
            };
            "nixd" = {
              "formatting" = {
                "command" = [
                  "nixfmt"
                ];
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake \"${self}\").nixosConfigurations.${hostname}.options";
                };
                "home-manager" = {
                  "expr" =
                    "(builtins.getFlake \"${self}\").nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []";
                };
              };
            };
          };
        };
      };
    };
  };

  programs.mpv.enable = true;
  programs.discord.enable = true;
  programs.joplin-desktop.enable = true;
  programs.firefox = {
    enable = true;
    policies = {
      CaptivePortal = false;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      FirefoxHome = {
        Search = false;
        TopSites = false;
        Highlights = false;
        Pocket = false;
        Snippets = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        SkipOnboarding = true;
      };
      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
      };
      ExtensionSettings = {
        "*@mozilla.org" = {
          installation_mode = "blocked";
        };
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "normal_installed";
        };
        "addon@darkreader.org" = {
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "normal_installed";
        };
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
          installation_mode = "normal_installed";
        };
        "FirefoxColor@mozilla.com" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
    profiles.default = {
      settings = {
        "general.smoothScroll.msdPhysics.enabled" = true;
        "browser.startup.page" = 3;
      };
      extensions.force = true;
    };
  };

  home.packages = with pkgs; [
    spotify
    bolt-launcher
    qbittorrent
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
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

  programs.plasma = {
    enable = true;

    panels = [
      {
        location = "top";
        widgets = [
          {

            iconTasks = {
              launchers = [
                "preferred://browser"
                "applications:systemsettings.desktop"
                "applications:org.kde.konsole.desktop"
                "preferred://filemanager"
                "applications:discord.desktop"
                "applications:spotify.desktop"
                "applications:steam.desktop"
                "applications:Bolt.desktop"
                "applications:org.prismlauncher.PrismLauncher.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = { };
          }
          {
            digitalClock = {
              time.showSeconds = "always";
              time.format = "12h";
            };
          }
        ];
        screen = "all";
        floating = true;
      }
    ];

    configFile = {
      kcminputrc."Libinput/1133/49300/Logitech PRO X Wireless".PointerAccelerationProfile = 1;
      kcminputrc."Libinput/1133/50503/Logitech USB Receiver".PointerAccelerationProfile = 1;
      kcminputrc."Libinput/13364/2355/Keychron Keychron V3 Max Mouse".PointerAccelerationProfile = 1;
      # kcminputrc.Mouse.cursorSize = 42;
      # kcminputrc.Mouse.cursorTheme = "LUCY_UH";
      kded5rc.Module-browserintegrationreminder.autoload = false;
      kded5rc.Module-device_automounter.autoload = false;
      kdeglobals.General.UseSystemBell = true;
      kdeglobals.KDE.ShowDeleteCommand = false;
      # kdeglobals."KFileDialog Settings"."Allow Expansion" = false;
      kdeglobals."KFileDialog Settings"."Automatically select filename extension" = true;
      # kdeglobals."KFileDialog Settings"."Breadcrumb Navigation" = true;
      # kdeglobals."KFileDialog Settings"."Decoration position" = 2;
      # kdeglobals."KFileDialog Settings"."Preview Width" = 320;
      # kdeglobals."KFileDialog Settings"."Show Full Path" = false;
      # kdeglobals."KFileDialog Settings"."Show Inline Previews" = true;
      kdeglobals."KFileDialog Settings"."Show Preview" = true;
      # kdeglobals."KFileDialog Settings"."Show Speedbar" = true;
      kdeglobals."KFileDialog Settings"."Show hidden files" = true;
      # kdeglobals."KFileDialog Settings"."Sort by" = "Name";
      # kdeglobals."KFileDialog Settings"."Sort directories first" = true;
      # kdeglobals."KFileDialog Settings"."Sort hidden files last" = false;
      # kdeglobals."KFileDialog Settings"."Sort reversed" = false;
      # kdeglobals."KFileDialog Settings"."Speedbar Width" = 140;
      kdeglobals."KFileDialog Settings"."View Style" = "DetailTree";
      # kdeglobals.PreviewSettings.EnableRemoteFolderThumbnail = false;
      kdeglobals.PreviewSettings.MaximumRemoteSize = 3145728000;
      kiorc.Confirmations.ConfirmDelete = true;
      kiorc.Confirmations.ConfirmEmptyTrash = true;
      kiorc.Confirmations.ConfirmTrash = false;
      kiorc."Executable scripts".behaviourOnLaunch = "alwaysAsk";
      krunnerrc.General.FreeFloating = true;
      # kscreenlockerrc.Daemon.Timeout = 30;
      # kservicemenurc.Show.compressfileitemaction = true;
      # kservicemenurc.Show.extractfileitemaction = true;
      # kservicemenurc.Show.forgetfileitemaction = true;
      # kservicemenurc.Show.hidefileitemaction = false;
      # kservicemenurc.Show.installFont = true;
      # kservicemenurc.Show.kactivitymanagerd_fileitem_linking_plugin = true;
      # kservicemenurc.Show.kio-admin = true;
      # kservicemenurc.Show.makefileactions = true;
      # kservicemenurc.Show.mountisoaction = true;
      # kservicemenurc.Show.movetonewfolderitemaction = true;
      # kservicemenurc.Show.runInKonsole = true;
      # kservicemenurc.Show.setfoldericonitemaction = true;
      # kservicemenurc.Show.slideshowfileitemaction = true;
      # kservicemenurc.Show.tagsfileitemaction = true;
      # kservicemenurc.Show.wallpaperfileitemaction = true;
      # kwalletrc.Wallet."First Use" = false;
      kwinrc.Plugins.shakecursorEnabled = false;
      plasmaparc.General.AudioFeedback = false;
      plasmaparc.General.VolumeStep = 1;
      spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
      spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";
    };
  };
}
