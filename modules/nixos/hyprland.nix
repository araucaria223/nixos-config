{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hyprland.enable = lib.my.mkDefaultTrueEnableOption "hyprland";

  config = lib.mkIf config.hyprland.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.hyprland.enable = true;

    security.polkit.enable = true;
  };
}
