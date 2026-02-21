{
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
  };

  programs.zsh.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.sessionVariables = {
    VISUAL = "nvim";
  };

  environment.systemPackages = [
    pkgs.bind.dnsutils
    pkgs.cifs-utils
    pkgs.caligula
    pkgs.curl
    pkgs.dnsmasq
    pkgs.git
    pkgs.htop
    pkgs.lm_sensors
    pkgs.nmap
    pkgs.p7zip
    pkgs.tree
    pkgs.unrar
    pkgs.wget
  ];

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  networking.networkmanager.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "99-gaming-latency-fix" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 48000 ];
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
          # "default.clock.quantum" = 1024;
        };
      };
    };

    extraConfig.pipewire-pulse = {
      "99-pulse-discord-fix" = {
        "pulse.properties" = {
          "pulse.min.req" = "1024/48000";
          "pulse.min.frag" = "1024/48000";
          "pulse.min.quantum" = "1024/48000";
        };
      };
    };

    wireplumber.extraConfig = {
      "99-amd-hardware-tuning" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "node.name" = "~alsa_output.*"; } ];
            actions = {
              update-properties = {
                "session.suspend-on-idle" = false;
                "api.alsa.period-size" = 512;
                "api.alsa.headroom" = 1024;
              };
            };
          }
        ];
      };
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts
    ];
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  networking.firewall.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          curl
          gtk3
          libepoxy
          librsvg
          libsoup_3
          webkitgtk_4_1
        ];
    };
  };

  systemd.user.settings.Manager = {
    DefaultLimitNOFILE = 32000;
  };
}
