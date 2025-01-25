{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  options.hyprpanel.enable = lib.mkEnableOption ''
    hyprpanel - a bar based on astal
  '';

  config.programs.hyprpanel = lib.mkIf config.hyprpanel.enable {
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
      bar.clock = {
        format = "%a %d/%m %H:%M";
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
}
