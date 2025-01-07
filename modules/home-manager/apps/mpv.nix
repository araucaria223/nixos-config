{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mpv.enable = lib.mkDefaultTrueEnableOption ''
    mpv video player
  '';

  config.programs.mpv = lib.mkIf config.mpv.enable {
    enable = true;
    script = with pkgs.mpvScripts; [
      modernx
      thumbfast
    ];

    config = {
      osc = false;
      border = false;
    };
  };
}
