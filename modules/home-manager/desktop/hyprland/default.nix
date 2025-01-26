{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.my.validImports ./.;

  options.hyprland.enable = lib.my.mkDefaultTrueEnableOption ''
    hyprland home-manager configuration
  '';

  config = lib.mkIf config.hyprland.enable {
    # Enable the hyprland desktop portal
    xdg.portal = with pkgs; rec {
      enable = true;
      extraPortals = [xdg-desktop-portal-hyprland];
      configPackages = extraPortals;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings = {
        monitor = [",preffered,auto,1"];
        input = {
          follow_mouse = true;
          touchpad = {
            natural_scroll = false;
            scroll_factor = 0.6;
            disable_while_typing = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 1;
          layout = "dwindle";
        };

        decoration = {
          # Disable window rounding
          rounding = 0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 400;
          workspace_swipe_invert = false;
          workspace_swipe_min_speed_to_force = 0;
          workspace_swipe_cancel_ratio = 0.2;
        };

        misc = {
          disable_hyprland_logo = true;
          vfr = true;
          vrr = 1;

          /*
          Window swallowing -
          graphical apps launched from a terminal
          will 'swap out' with the terminal
          and swap back when they are closed
          */
          enable_swallow = true;
          swallow_regex = "^(kitty)$";
          swallow_exception_regex = "^(wev)$";

          focus_on_activate = true;
        };
      };
    };
  };
}
