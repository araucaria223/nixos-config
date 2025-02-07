{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = lib.mkIf config.hyprland.enable {
    plugins = with pkgs.hyprlandPlugins; [
      # Workspace overview
      hyprexpo
    ];

    settings = {
      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 20;
          workspace_method = "first 1";
          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 200;
          gesture_positive = true;
        };
      };

      bind = [
        "$mod, down, hyprexpo:expo, enable"
        "$mod, up, hyprexpo:expo, disable"
        ", Escape, hyprexpo:expo, disable"
      ];
    };
  };
}
