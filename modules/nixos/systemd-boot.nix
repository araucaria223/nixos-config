{
  config,
  lib,
  ...
}: {
  options.systemd-boot.enable = lib.my.mkDefaultTrueEnableOption "systemd-boot";

  config.boot.loader = lib.mkIf config.systemd-boot.enable {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
