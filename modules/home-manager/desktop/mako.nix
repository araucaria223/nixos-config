{
  config,
  lib,
  ...
}: {
  options.mako.enable = lib.my.mkDefaultTrueEnableOption ''
    mako notification daemon
  '';

  config.services.mako = lib.mkIf config.mako.enable {
    enable = true;
    borderRadius = 5;
    borderSize = 2;
    layer = "overlay";
    defaultTimeout = 1000;
  };
}
