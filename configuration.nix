{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ############################################
  # Nix stuff                                #
  ############################################
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [ "openssl-1.1.1w" ]; # Bolt (rs3)
  };

  ############################################
  # Boot                                     #
  ############################################
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  ############################################
  # Security                                 #
  ############################################
  security = {
    # For realtime scheduling procs like pulseaudio / pipewire
    rtkit.enable = true;
  };

  ############################################
  # Services                                 #
  ############################################
  services = {
    # Needed for GC controller
    udev.packages = [ pkgs.dolphin-emu ];

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver = {
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    desktopManager = {
      plasma6.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Mullvad
    resolved.enable = true;
    mullvad-vpn.enable = true;
    mullvad-vpn.package = pkgs.mullvad-vpn; # Specified for desktop pkg
  };

  ############################################
  # Hardware                                 #
  ############################################
  chaotic.mesa-git.enable = true;
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  virtualisation = {
    docker.enable = true;
  };

  ############################################
  # Networking                               #
  ############################################
  networking = {
    hostName = "redbox";
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  ############################################
  # Locale                                   #
  ############################################
  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  ############################################
  # Fonts                                    #
  ############################################
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  ############################################
  # Users                                    #
  ############################################
  users = {
    defaultUserShell = pkgs.zsh;
    users.rehmans = {
      isNormalUser = true;
      description = "Syed Rehman";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      packages = with pkgs; [
        kdePackages.kate
        kdePackages.yakuake
        kdePackages.ffmpegthumbs
        kdePackages.colord-kde
      ];
    };
  };

  ############################################
  # Programs                                 #
  ############################################
  programs = {
    zsh.enable = true;
    firefox.enable = true;

    nixvim = {
      enable = true;
      defaultEditor = true;

      colorschemes.catppuccin.enable = true;
      plugins = {
        lualine.enable = true;
        nix.enable = true;
        neoscroll.enable = true;
        mini = {
          enable = true;

          modules.icons = { };
          mockDevIcons = true;
        };

        # Language server
        lsp = {
          enable = true;
          inlayHints = true;
          servers = {
            nil_ls.enable = true;
            rust_analyzer = {
              enable = true;
              installRustc = true;
              installCargo = true;
            };
            nixd = {
              enable = true;
              settings =
                let
                  flake = ''(builtins.getFlake "/etc/nixos)""'';
                in
                {
                  nixpkgs = {
                    expr = "import ${flake}.inputs.nixpkgs { }";
                  };
                  formatting = {
                    command = [ "nixpkgs-fmt" ];
                  };
                  options = {
                    nixos.expr = "${flake}.nixosConfigurations.redbox.options";
                  };
                };
            };
          };
        };

        neo-tree = {
          enable = true;
          enableDiagnostics = true;
          enableGitStatus = true;
          enableModifiedMarkers = true;
          enableRefreshOnWrite = true;
          closeIfLastWindow = true;
          popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
          buffers = {
            bindToCwd = false;
            followCurrentFile = {
              enabled = true;
            };
          };
        };

        luasnip = {
          enable = true;
          fromVscode = [ { } ];
        };
        friendly-snippets.enable = true;

        cmp = {
          enable = true;
          autoEnableSources = true;

          settings = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "luasnip"; }
            ];

            mapping = {
              "<C-d>" = # Lua
                "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = # Lua
                "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = # Lua
                "cmp.mapping.complete()";
              "<C-e>" = # Lua
                "cmp.mapping.close()";
              "<Tab>" = # Lua
                "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
              "<S-Tab>" = # Lua
                "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
              "<CR>" = # Lua
                "cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })";
            };
          };
        };
      };
    };

    # TODO: See if this is still useful
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };

  ############################################
  # Packages                                 #
  ############################################
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    mangohud
    protonup-qt
    htop
    vscode
    nixd
    nixfmt-rfc-style
    cifs-utils
    caligula
    git
    godot
    caligula
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
