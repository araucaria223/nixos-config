{
  config,
  lib,
  ...
}: {
  options.geoclue.enable = lib.mkEnableOption ''
    Enable geoclue2 geolocation
  '';

  config.services = lib.mkIf config.geoclue.enable {
    geoclue2 = {
      enable = true;
      geoProviderUrl = "https://beacondb.net/v1/geolocate";
    };

    automatic-timezoned.enable = true;
  };
}
