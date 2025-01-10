{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hyprland.enable = lib.my.mkDefaultTrueEnableOption "hyprland";

  config = lib.mkIf config.hyprland.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.hyprland = {
      enable = true;
      # Use the package provided by the flake
      # package = pkgs.unstable.hyprland;
      # portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
    };
  };
}
