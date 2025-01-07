{
  config,
  lib,
  ...
}: {
  options.zathura = {
    enable = lib.my.mkDefaultTrueEnableOption ''
      zathura pdf viewer
    '';

    isDefault = lib.mkOption {
      default = true;
      example = false;
      description = ''
        Whether zathura is the default pdf viewer
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.zathura.enable {
    xdg.mimeApps = lib.mkIf config.zathura.isDefault {
      associations.added = {
        "application/pdf" = ["zathura.desktop"];
      };
      defaultApplications = {
        "application/pdf" = ["zathura.desktop"];
      };
    };

    programs.zathura = {
      enable = true;
      options = {
        recolor = true;
        recolor-keephue = true;
      };
    };
  };
}
