{
  config,
  lib,
  ...
}: {
  options.pipewire.enable = lib.my.mkDefaultTrueEnableOption "pipewire";

  config = lib.mkIf config.pipewire.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
	enable = true;
	support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
