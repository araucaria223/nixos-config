{ pkgs, config, lib, ... }:

{
  options = {
    mako.enable = lib.mkEnableOption "enable mako";
  };

  config = lib.mkIf config.mako.enable {
    services.mako = with config.colorScheme.palette; {
      enable = true;
      backgroundColor = "#${base01}";
      borderColor = "#${base0E}";
      borderRadius = 5;
      borderSize = 2;
      textColor = "#${base04}";
      layer = "overlay";
    };
  };
}
