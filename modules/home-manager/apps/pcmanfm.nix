{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pcmanfm;
in {
  options.pcmanfm = {
    enable = lib.my.mkDefaultTrueEnableOption "pcmanfm";
    isDefault = lib.mkOption {
      default = true;
      example = false;
      description = ''
	Whether pcmanfm should be the default file manager
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.pcmanfm];

    # Optionally set pcmanfm as default file manager
    xdg.mimeApps = lib.mkIf cfg.isDefault {
      associations.added = {
        "inode/directory" = ["pcmanfm.desktop"];
      };
      defaultApplications = {
        "inode/directory" = ["pcmanfm.desktop"];
      };
    };
  };
}
