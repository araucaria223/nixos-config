{
  config,
  lib,
  ...
}: {
  options.hyprlock.enable = lib.my.mkDefaultTrueEnableOption "hyprlock";

  config = lib.mkIf config.hyprlock.enable {
    # Disable stylix management of hyprlock
    stylix.targets.hyprlock.enable = false;

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };
        background = {
          path = "${config.stylix.image}";
          blur_passes = 2;
          blur_size = 7;
        };

        label = {
          text = "$TIME";
          text_align = "center";
          font_size = 50;

          position = "0, 80";
          halign = "center";
          valign = "center";
        };

        input-field = with config.lib.stylix.colors; {
          size = "180, 30";
          outline_thickness = 3;
          dots_size = 0.20;
          dots_spacing = 1;
          dots_center = false;
          dots_rounding = -1;
          # Transparent
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(${base01}b3)";
          font_color = "rgb(${base06})";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Input password</i>";
          hide_input = false;
          rounding = 10;
          check_color = "rgb(${base0A})";
          fail_color = "rgb(${base08})";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
