{
  config,
  lib,
  ...
}: {
  options.zathura.enable = lib.my.mkDefaultTrueEnableOption ''
    zathura pdf viewer
  '';

  config.programs.zathura = lib.mkIf config.zathura.enable {
    enable = true;
    options = {
      recolor = true;
      recolor-keephue = true;
    };
  };
}
