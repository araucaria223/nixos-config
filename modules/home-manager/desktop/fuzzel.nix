{
  config,
  lib,
  pkgs,
  settings,
  ...
}: {
  options.fuzzel.enable = lib.my.mkDefaultTrueEnableOption "fuzzel";

  config = lib.mkIf config.fuzzel.enable {
    # Persist bemoji emojis
    home.persistence."/persist/home/${config.home.username}".directories =
      lib.my.symlink [".local/share/bemoji"];

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = lib.getExe pkgs.${settings.defaultTerminal};
          icon-theme = "${config.stylix.iconTheme.dark}";
          prompt = "​";
          password-character = "*";
          match-mode = "fuzzy";
          show-actions = false;
          icons-enabled = true;
          dpi-aware = "auto";
          font = lib.mkForce "monospace:size=11";

          anchor = "center";
          lines = 10;
          width = 20;
          tabs = 4;
          horizontal-pad = 18;
          vertical-pad = 8;
          inner-pad = 0;
          image-size-ratio = 0.5;

          line-height = 20;
          letter-spacing = 0;
          layer = "top";
          exit-on-keyboard-focus-loss = true;
        };

        border = {
          width = 0;
          radius = 8;
        };
      };
    };
  };
}
