{
  config,
  hostname,
  pkgs,
  ...
}:

let
  fluxerDesktop = pkgs.callPackage ../../pkgs/fluxer-desktop.nix { };

  configDirName =
    {
      "vscode" = "Code";
      "vscode-insiders" = "Code - Insiders";
      "vscodium" = "VSCodium";
    }
    .${config.programs.vscode.package.pname};
  configPath = "${config.xdg.configHome}/${configDirName}/User/settings.json";
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
    autosuggestion.enable = true;
    sessionVariables = {
      LESS = "-g -i -M -R -S -w";
    };
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
      obs-vaapi
    ];
  };

  programs.git = {
    enable = true;
  };

  programs.kodi = {
    enable = true;
    sources = {
      files = {
        source = [
          {
            name = "fen";
            path = "https://fenlightanonymouse.github.io/packages/";
            allowsharing = "true";
          }
          {
            name = "coco";
            path = "https://cocojoe2411.github.io/";
            allowsharing = "true";
          }
          {
            name = "fentastic";
            path = "https://ivarbrandt.github.io/repository.ivarbrandt/";
            allowsharing = "true";
          }
        ];
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
    profiles = {
      default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          mkhl.direnv
          jnoortheen.nix-ide
          usernamehw.errorlens
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ];

        userSettings = {
          "chat.disableAIFeatures" = true;
          "direnv.restart.automatic" = true;
          "editor.smoothScrolling" = true;
          "editor.formatOnSave" = true;
          "extensions.ignoreRecommendations" = true;
          "files.autoSave" = "afterDelay";
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
              "nixpkgs" = {
                "expr" = "import (builtins.getFlake \"/home/rehmans/nixos\").inputs.nixpkgs { }";
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options";
                };
                "home-manager" = {
                  "expr" =
                    "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []";
                };
              };
            };
          };
          "telemetry.editStats.enabled" = false;
          "telemetry.feedback.enabled" = false;
          "telemetry.telemetryLevel" = "off";
          "workbench.colorTheme" = "Catppuccin Macchiato";
          "workbench.commandPalette.showAskInChat" = false;
          "workbench.editor.enablePreview" = false;
          "workbench.settings.showAISearchToggle" = false;
          "workbench.startupEditor" = "none";
        };
      };
    };
  };

  # https://github.com/nix-community/home-manager/issues/1800#issuecomment-2262881846
  home.activation.makeVSCodeConfigWritable = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      install -m 0640 "$(readlink ${configPath})" ${configPath}
    '';
  };

  home.file."${configPath}" = {
    force = true;
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
        # "FirefoxColor@mozilla.com" = {
        #   default_area = "menupanel";
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
        #   installation_mode = "normal_installed";
        # };
      };
    };
    profiles.default = {
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.ml.linkPreview.enabled" = false;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "browser.startup.page" = 3;
        "signons.management.page.breah-alerts.enabled" = false;
        "signons.rememberSignons" = false;
        "browser.ai.control.default" = "blocked";
        "extensions.ml.enabled" = false;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };
      extensions.force = true;
      isDefault = true;
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
    easyeffects
    devenv
    signal-desktop
    fluxerDesktop
    tldr
    protonplus
  ];
}
