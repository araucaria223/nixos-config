{
  config,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings.animations = lib.mkIf config.hyprland.enable {
    enabled = true;
    bezier = [
      "myBezier, 0.05, 0.9, 0.1, 1.05"

      "linear, 0, 0, 1, 1"
      "md3_standard, 0.2, 0, 0, 1"
      "md3_decel, 0.05, 0.7, 0.1, 1"
      "md3_accel, 0.3, 0, 0.8, 0.15"
      "overshot, 0.05, 0.9, 0.1, 1.1"
      "crazyshot, 0.1, 1.5, 0.76, 0.92"
      "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
      "menu_decel, 0.1, 1, 0, 1"
      "menu_accel, 0.38, 0.04, 1, 0.07"
      "easeInOutCirc, 0.85, 0, 0.15, 1"
      "easeOutCirc, 0, 0.55, 0.45, 1"
      "easeOutExpo, 0.16, 1, 0.3, 1"
      "softAcDecel, 0.26, 0.26, 0.15, 1"
      "md2, 0.4, 0, 0.2, 1"
    ];

    animation = [
      "windows, 1, 7, myBezier"
      "windowsIn, 1, 7, myBezier, slide"
      "windowsOut, 1, 7, default, slide"

      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
      "specialWorkspace, 1, 3, md3_decel, slidevert"
    ];
  };
}
