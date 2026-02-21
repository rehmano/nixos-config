{
  config,
  pkgs,
  ...
}:

{
  boot.kernel.sysctl = {
    # https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter-main/os/x86_64/steamos-customizations-jupiter-20260428.1-1-any.pkg.tar.zst
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.ipv4.tcp_fin_timeout" = 5;
    "kernel.split_lock_mitigate" = 0;
    "vm.max_map_count" = 2147483642;

    # https://github.com/CachyOS/CachyOS-Settings/blob/002d4bbdc12c1ed84f52d66a47875d3e63460b18/usr/lib/sysctl.d/70-cachyos-settings.conf
    "vm.swappiness" = 100;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 67108864;
    "vm.dirty_writeback_centisecs" = 1500;
    "kernel.nmi_watchdog" = 0;
    "kernel.unprivileged_userns_clone" = 1;
    "kernel.printk" = "3 3 3 3";
    "kernel.kptr_restrict" = 2;
    "net.core.netdev_max_backlog" = 4096;
    "fs.file-max" = 2097152;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  services.udev.extraRules = ''
    ACTION=="change", KERNEL=="zram0", ATTR{initstate}=="1", SYSCTL{vm.swappiness}="150", RUN+="${pkgs.bash}/bin/bash -c 'echo N > /sys/module/zswap/parameters/enabled'"
  '';

  environment.sessionVariables = {
    # PROTON_ENABLE_WAYLAND = 1;
    # PROTON_USE_OPTISCALER = 1;
    # PROTON_NO_WM_DECORATION = 1;
    PROTON_DISCORD_BRIDGE = 1;
    LOW_LATENCY_LAYER = 1;
    # MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };

  boot.extraModulePackages = [
    config.boot.kernelPackages.gcadapter-oc-kmod
  ];

  # to autoload at boot:
  boot.kernelModules = [
    "gcadapter_oc"
    "uinput"
  ];

  # Switched to zram in gaming
  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
      priority = 0; # ONLY touched if ZRAM is 100% full
    }
  ];
}
