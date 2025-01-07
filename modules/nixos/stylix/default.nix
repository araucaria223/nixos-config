{
  lib,
  pkgs,
  settings,
  ...
}: {
  imports = lib.my.validImports ./.;

  stylix = {
    # Global colour scheme
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${settings.colorScheme}.yaml";
    # Wallpaper image
    image = lib.my.paths.assets + /wallpapers/${settings.wallpaper};
  };
}
