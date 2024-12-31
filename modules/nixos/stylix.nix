{
  config,
  lib,
  pkgs,
  settings,
  ...
}: {
  options.stylix-theme.enable = lib.mkEnableOption ''
    Enable stylix theming
  '';

  config.stylix = lib.mkIf config.stylix-theme.enable {
    enable = true;
    # Global colour scheme
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${settings.colorScheme}.yaml";
    # Wallpaper image
    image = builtins.toPath "${lib.my.paths.assets}/wallpapers/${settings.wallpaper}";

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 4;
    };

    fonts = {
      monospace = {
        package = pkgs.unstable.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 10;
        popups = 10;
      };
    };
  };
}
