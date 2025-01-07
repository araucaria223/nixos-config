{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mpv.enable = lib.my.mkDefaultTrueEnableOption ''
    mpv video player
  '';

  config.programs.mpv = lib.mkIf config.mpv.enable {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      modernx
      thumbfast
    ];

    config = {
      osc = false;
      border = false;
    };
  };
}
