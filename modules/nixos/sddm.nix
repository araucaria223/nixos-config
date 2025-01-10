{
  config,
  lib,
  settings,
  ...
}: {
  options.sddm.enable = lib.my.mkDefaultTrueEnableOption ''
    SDDM display manager
  '';

  config.services.displayManager.sddm = lib.mkIf config.sddm.enable {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
	Session = "Hyprland.desktop";
	User = settings.username;
      };
    };
  };
}
