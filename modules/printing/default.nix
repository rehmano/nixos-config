{
  pkgs,
  ...
}:

{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  hardware = {
    # Brother scanner
    sane = {
      enable = true;
      brscan5.enable = true;
    };
  };
}
