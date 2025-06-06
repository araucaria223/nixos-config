{
  config,
  lib,
  settings,
  ...
}: {
  options.greetd.enable = lib.mkEnableOption "greetd";

  config.services.greetd = lib.mkIf config.greetd.enable {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${config.programs.hyprland.package}/bin/Hyprland";
        user = config.users.users.${settings.username}.name;
      };
      default_session = initial_session;
    };
  };
}
