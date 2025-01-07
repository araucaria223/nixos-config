{
  config,
  lib,
  ...
}: {
  options.gammastep.enable = lib.my.mkDefaultTrueEnableOption "gammastep";

  config.services.gammastep = lib.mkIf config.gammastep.enable {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 3700;
    };
  };
}
