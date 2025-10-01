{
  config,
  lib,
  ...
}: {
  options.geoclue.enable = lib.my.mkDefaultTrueEnableOption ''
    geoclue2 geolocation
  '';

  config.services = lib.mkIf config.geoclue.enable {
    geoclue2 = {
      enable = true;
      geoProviderUrl = "api.beacondb.net/v1/geolocate";
    };

    avahi.enable = true;

    automatic-timezoned.enable = true;
  };
}
