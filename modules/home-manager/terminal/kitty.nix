{
  config,
  lib,
  ...
}: {
  options.kitty.enable = lib.mkEnableOption ''
    Enable kitty terminal
  '';

  config.programs.kitty = lib.mkIf config.kitty.enable {
    enable = true;
    settings = {
      scrollback_lines = 1000;
      enable_audio_bell = false;
      disable_ligatures = "never";

      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
  };
}
