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

      windowrulev2 = ["workspace special:hyprpanel-settings, title:(hyprpanel-settings)"];
    };

    # Provision weather api key secret
    sops.secrets."weather.json" = {};

    programs.hyprpanel = {
      enable = true;
      overlay.enable = true;
      hyprland.enable = true;

      layout = {
        "bar.layouts"."0" = {
          left = ["dashboard" "workspaces"];
          middle = ["media"];
          right = ["volume" "bluetooth" "battery" "systray" "clock" "notifications"];
        };
      };

      settings = {
        bar = {
          workspaces.ignored = ''^-\\d+$'';
          clock.format = "%a %d/%m %H:%M";
          media.show_active_only = true;
          launcher.autoDetectIcon = true;
        };

        menus = {
          clock = {
            time = {
              hideSeconds = true;
              military = true;
            };

            weather = {
	      unit = "metric";
	      key = config.sops.secrets."weather.json".path;
	    };
          };

          dashboard = {
            directories.enabled = false;
          };
        };
      };
    };
  };
}
