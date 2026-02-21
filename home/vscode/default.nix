{
  config,
  hostname,
  pkgs,
  ...
}:

let
  configPath = "${config.xdg.configHome}/VSCodium/User/settings.json";
in
{
  # Switching to vscodium for now due to https://github.com/NixOS/nixpkgs/issues/560776
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (
      ps: with ps; [
        nil
        nixd
        rustup
        zlib
      ]
    );
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
}
