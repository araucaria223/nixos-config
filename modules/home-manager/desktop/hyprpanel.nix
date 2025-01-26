{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  options.hyprpanel.enable = lib.mkEnableOption ''
    hyprpanel - a bar based on astal
  '';

  config = lib.mkIf config.hyprpanel.enable {
    wayland.windowManager.hyprland.settings = lib.mkIf config.hyprland.enable {
      bind = [
	"$mod SHIFT, P, exec, ${lib.getExe pkgs.hyprpanel} t powermenu"
      ];
    };

    programs.hyprpanel = {
      enable = true;
      overlay.enable = true;
      hyprland.enable = true;

      layout = {
        "bar.layouts"."0" = {
          left = ["dashboard" "workspaces"];
          middle = ["media"];
          right = ["volume" "netstat" "bluetooth" "battery" "systray" "clock" "notifications"];
        };
      };

      settings = {
        bar = {
          clock.format = "%a %d/%m %H:%M";
          media.show_active_only = true;
        };

        menus = {
          clock = {
            time = {
              hideSeconds = true;
              military = true;
            };

            weather.unit = "metric";
          };

          dashboard = {
            directories.enabled = false;
          };
        };
      };
    };
  };
}
