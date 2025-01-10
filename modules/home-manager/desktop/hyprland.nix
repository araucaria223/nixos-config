{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [grim slurp swappy];
    text = ''pgrep slurp || grim -g "$(slurp)" - | swappy -f'';
  };

  color-picker = pkgs.writeShellApplication {
    name = "color-picker";
    runtimeInputs = [pkgs.hyprpicker];
    text = /*sh*/ "hyprpicker --autocopy";
  };
in {
  options.hyprland.enable = lib.my.mkDefaultTrueEnableOption ''
    hyprland home-manager configuration
  '';

  config = lib.mkIf config.hyprland.enable {
    xdg = {
      # Enable the hyprland desktop portal
      # portal = with inputs.hyprland.packages.${pkgs.system}; {
      #   enable = true;
      #   extraPortals = [xdg-desktop-portal-hyprland];
      #   configPackages = [xdg-desktop-portal-hyprland];
      # };
      portal = with pkgs; {
	enable = true;
	extraPortals = [xdg-desktop-portal-hyprland];
	configPackages = [xdg-desktop-portal-hyprland];
      };

      mimeApps.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      # Use the package from the hyprland flake
      #package = inputs.hyprland.packages.${pkgs.system}.hyprland;

      # plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
      #   # Workspace overview
      #   hyprexpo
      # ];

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

        animations = {
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

        windowrule = [
          "move 0 0,title:^(Save Image)(.*)$"
        ];
        windowrulev2 = [
          # Stop programs launching maximised
          "suppressevent maximise, class:.*"
          # Make calculator float above windows
          "float, class:(qalculate-gtk)"
          # Spawn calculator in special workspace
          "workspace special:calculator,class:(qalculate-gtk)"
        ];

        workspace = let
          cal = "${pkgs.qalculate-gtk}/bin/qalculate-gtk";
          btm = "${pkgs.kitty}/bin/kitty -e ${pkgs.bottom}/bin/btm -b";
        in [
          # Launch bottom system monitor
          # If system scratchpad opened empty
          "special:system, on-created-empty:${btm}"
          # Launch calculator
          "special:calculator, on-created-empty:${cal}"
        ];

        exec-once = [];

        # Repeat if held
        binde = let
          pmx = "${pkgs.pamixer}/bin/pamixer";
          bct = "${pkgs.brightnessctl}/bin/brightnessctl";
        in [
          ",XF86AudioRaiseVolume, exec, ${pmx} -i 5"
          ",XF86AudioLowerVolume, exec, ${pmx} -d 5"
          ",XF86AudioMute, exec, ${pmx} --toggle-mute"

          ",XF86MonBrightnessUp, exec, ${bct} s +5%"
          ",XF86MonBrightnessDown, exec, ${bct} s 5%-"
          "CTRL,XF86MonBrightnessUp, exec, ${bct} s +1%"
          "CTRL,XF86MonBrightnessDown, exec, ${bct} s 1%-"
        ];

	"$mod" = "SUPER";

        # Regular keybinds
        bind = let
          kitty = "${pkgs.kitty}/bin/kitty";
          fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
          bemoji = "${pkgs.bemoji}/bin/bemoji";
          screen = "${screenshot}/bin/screenshot";
          colpick = "${color-picker}/bin/color-picker";
          hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
          pct = "${pkgs.playerctl}/bin/playerctl";
        in [
          # Kill active window
          "$mod, Q, killactive"
          # Float active window
          "$mod, V, togglefloating"
          # Fullscreen active window
          "$mod, F, fullscreen, 0"
          /*
             Client fullscreen active window -
          useful for fullscreening videos
          without fullscreening the whole window
          */
          "$mod SHIFT, F, fullscreenstate, -1 1"
          # Maximise active window
          "$mod, M, fullscreen, 1"

          # Change the split orientation
          "$mod, D, togglesplit"
          # Toggle workspace overview
	    #"$mod SHIFT, Space, hyprexpo:expo, toggle"

	  # Change focused window
	  "$mod, H, movefocus, r"
	  "$mod, J, movefocus, d"
	  "$mod, K, movefocus, u"
	  "$mod, L, movefocus, l"

          # Media keys
          ",XF86AudioPlay, exec, ${pct} play-pause"
          ",XF86AudioNext, exec, ${pct} next"
          ",XF86AudioPrev, exec, ${pct} previous"

	  # Terminal
	  "$mod, Return, exec, ${kitty}"
	  # Application launcher
	  "$mod, Space, exec, pgrep fuzzel || ${fuzzel}"
	  # Emoji search
	  "$mod SHIFT, E, exec, pgrep fuzzel || ${bemoji}"
	  # Color picker
	  "$mod SHIFT, C, exec, ${colpick}"
	  # Screenshot
	  "$mod SHIFT, S, exec, ${screen}"
	  # Lock screen
	  "$mod SHIFT, L, exec, pgrep hyprlock || ${hyprlock}"
	  # Reload wifi
	  "$mod, R, exec, wpa_cli reconnect"

	  # Scratchpads
	  "$mod, I, togglespecialworkspace, system"
	  "$mod, C, togglespecialworkspace, calculator"

	  # Scroll workspaces
	  "$mod, mouse_down, workspace, e+1"
	  "$mod, mouse_up, workspace, e-1"
        ]
	# Numbered binds for workspaces 1-9
	++ lib.concatMap (x: let
	  key = toString (lib.mod x 10);
	  wksp = toString x;
	in [
	  "$mod, ${key}, workspace, ${wksp}"
	  "$mod SHIFT, ${key}, movetoworkspace, ${wksp}"
	]) (lib.range 1 10);

	bindm = [
	  # $mod + left click to drag windows around
	  "$mod, move:272, movewindow"
	  # $mod + right click to resize windows
	  "$mod, mouse:273, resizewindow"
	];

	plugin.hyprexpo = {
	  columns = 3;
	  gap_size = 20;
	  workspace_method = "first 1";

	  # Three finger downward swipe
	  enable_gesture = true;
	  gesture_fingers = 3;
	  gesture_distance = 200;
	  gesture_positive = true;
	};
      };
    };
  };
}
