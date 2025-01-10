{
  config,
  lib,
  settings,
  ...
}: {
  options.greetd.enable = lib.my.mkDefaultTrueEnableOption "greetd";

  config.services.greetd = lib.mIf config.greetd.enable {
    enable = true;
    settings = rec {
      initial_session = {
	command = "${config.programs.hyprland.package}/bin/Hyprland";
	user = "${settings.username}";
      };
      default_session = initial_session;
    };
  };
}
