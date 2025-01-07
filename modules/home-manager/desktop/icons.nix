{
  config,
  lib,
  pkgs,
  ...
}: {
  options.icon-theme.enable = lib.my.mkDefaultTrueEnableOption "icon theme";

  config.stylix.iconTheme = lib.mkIf config.icon-theme.enable {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
    light = "Papirus-Light";
  };
}
