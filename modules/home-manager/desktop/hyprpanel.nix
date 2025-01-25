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

  config.programs.hyprpanel = lib.mkif config.hyprpanel.enable {
    enable = true;
    overlay.enable = true;
    systemd.enable = true;
    hyprland.enable = true;

    layout = {
      "0" = {
	left = ["dashboard workspaces"];
	middle = ["media"];
	right = ["volume" "bluetooth" "battery" "systray" "clock" "notifications"];
      };
    };
  };
}
