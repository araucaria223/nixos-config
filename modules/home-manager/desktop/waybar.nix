{
  config,
  lib,
  ...
}: {
  options.waybar.enable = lib.my.mkDefaultTrueEnableOption "waybar";

  config.programs.waybar = lib.mkIf config.waybar.enable {
    enable = true;
    settings.main-bar = {
      layer = "top";
      position = "top";
      mode = "dock";
      gtk-layer-shell = true;

      modules-left = [
	"hyprland/workspaces"
	"hyprland/window"
      ];

      modules-center = [
	"memory"
	"idle_inhibitor"
	"clock#time"
	"clock#date"
	"bluetooth"
      ];

      modules-right = [
	"pulseaudio"
	"battery"
      ];

      "hyprland/workspaces" = {
	on-scroll-up = "hyprctl dispatch workspace -1";
	on-scroll-down = "hyprctl dispatch workspace +1";
      };

      "hyprland/window" = {
	format = "{}";
	min-length = 5;
      };
    };
  };
}
