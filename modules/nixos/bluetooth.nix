{
  config,
  lib,
  ...
}: {
  options.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config.hardware.bluetooth = {
    enable = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };
}
