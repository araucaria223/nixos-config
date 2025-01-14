{
  config,
  lib,
  pkgs,
  ...
}: {
  options.stremio.enable = lib.my.mkDefaultTrueEnableOption "stremio";

  config = lib.mkIf config.stremio.enable {
    # Install stremio
    home.packages = [pkgs.stremio];
    # Persist stremio's data
    home.persistence."/persist/home/${config.home.username}".directories = [
      ".stremio-server"
      ".local/share/Smart Code ltd/Stremio"
      ".cache/Smart Code ltd/Stremio"
    ];
  };
}
