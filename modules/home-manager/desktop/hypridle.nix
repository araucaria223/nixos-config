{
  config,
  lib,
  pkgs,
  ...
}: let
  dim-screen = pkgs.writeShellApplication {
    name = "dim-screen";
    runtimeInputs = [pkgs.brightnessctl];
    text = ''
           brightnessctl -s
           until [ "$(brightnessctl g)" -lt 5000 ]; do
      brightnessctl set 5%-
      sleep 0.005
           done
    '';
  };
in {
  options.hypridle.enable = lib.my.mkDefaultTrueEnableOption "hypridle";

  config.services.hypridle = lib.mkIf config.hypridle.enable {
    enable = true;
    package = pkgs.unstable.hypridle;
    settings = {
      lock_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";

      listener = [
        {
          # 2.5 min - Dim screen
          timeout = 150;
          on-timeout = "${lib.getExe dim-screen}";
          on-resume = "${lib.getExe pkgs.brightnessctl} -r";
        }
        {
          # 5 min - Lock session
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          # 5.5 min - Turn screen off
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # 6 min - Sleep
          timeout = 400;
          on-timeout = "systemctl sleep";
        }
      ];
    };
  };
}
