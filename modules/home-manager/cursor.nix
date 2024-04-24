{ pkgs, lib, config, ... }:

{
  options = {
    cursor.enable = lib.mkEnableOption "enable cursor theme";
  };

  config = lib.mkIf config.cursor.enable {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };
}
