{
  config,
  lib,
  ...
}: {
  options.alacritty.enable = lib.my.mkDefaultTrueEnableOption "alacritty terminal";

  config.programs.alacritty = lib.mkIf config.alacritty.enable {
    enable = true;
    settings = {
      window.padding = {
        x = 15;
        y = 15;
      };
    };
  };
}
