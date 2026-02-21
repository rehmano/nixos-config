{
  config,
  ...
}:

{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
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
      };
    };
    profiles.default = {
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.ai.control.default" = "blocked";
        "browser.download.useDownloadsDir" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.startup.page" = 3;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "extensions.ml.enabled" = false;
        "media.hardwaremediakeys.enabled" = false;
        "signons.management.page.breach-alerts.enabled" = false;
        "signons.rememberSignons" = false;
      };
      extensions.force = true;
      isDefault = true;
    };
  };
}
