{
  ...
}:

{
  boot = {
    kernel.sysctl = {
      # Stop Multi-CCD mesh hopping
      "kernel.numa_balancing" = 0;
    };
    kernelParams = [
      "amdgpu.gpu_recovery=1"
      "amdgpu.gfx_off=0"
      "amdgpu.dcdebugmask=0x10"
      "amd_pstate=active"
    ];
  };

  hardware = {
    bluetooth.enable = true;
    opentabletdriver.enable = true;
    uinput.enable = true;

    amdgpu = {
      initrd.enable = true;
      # For LACT
      overdrive.enable = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Deathadder
    openrazer = {
      enable = true;
      users = [
        "rehmans"
      ];
      batteryNotifier.frequency = 1800;
      batteryNotifier.percentage = 20;
    };
  };

  services.xserver.videoDrivers = [
    "modesetting"
  ];

  services.pipewire = {
    extraConfig.pipewire = {
      "99-echo-cancel" = {
        "context.modules" = [
          {
            name = "libpipewire-module-echo-cancel";
            args = {
              monitor.mode = true;
              source.props = {
                node.name = "echo-cancel-source";
                node.description = "Echo Cancelled Mic";
              };

              capture.props = {
                node.name = "echo-cancel-capture";
                # From "pw-dump Node | jq -r '.[] | [.id, .info.props["node.name"]] | @tsv' | grep -E "echo|Mic1|Mic2""
                node.target = "alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7R9KDB2C0A0F3-00.HiFi__Mic1__source";
                node.passive = true;
              };
              aec.args = {
                # https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/51ea8aab2fd923fec3d8861cbfd623cad9bf69bd/spa/plugins/aec/aec-webrtc.cpp#L122
                webrtc.noise_suppression = false;
                # webrtc.high_pass_filter = false;
                # webrtc.extended_filter = false;
              };
            };
          }
        ];
      };
    };
  };
}
