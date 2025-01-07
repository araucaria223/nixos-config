{
  config,
  lib,
  pkgs,
  ...
}: {
  options.yazi.enable = lib.my.mkDefaultTrueEnableOption ''
    yazi file manager
  '';

  config = lib.mkIf config.yazi.enable {
    # Optional dependencies
    home.packages = with pkgs; [
      wl-clipboard
      unar
      jq
      poppler
      fd
      ripgrep
      zoxide
      ffmpegthumbnailer
    ];

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        opener = {
          play = [
            {
              run = ''mpv "$@"'';
              orphan = true;
              for = "unix";
            }
          ];
          edit = [
            {
              run = ''$EDITOR "$@"'';
              block = true;
              for = "unix";
            }
          ];
          open = [
            {
              run = ''xdg-open "$@"'';
              desc = "Open";
            }
          ];
        };

        input = {
          find_origin = "bottom-left";
          find_offset = [0 2 50 3];
        };
      };

      theme = {
        status = {
          separator_open = "█";
          separator_close = "█";
        };
      };
    };
  };
}
