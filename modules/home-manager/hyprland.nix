{ pkgs, lib, config, ... }:

{
  options = {
    hyprland.enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf config.hyprland.enable {

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [
        "eDP-1,1440x900@60,0x0,1"
      ];
      input = {
        follow_mouse = "true";

	touchpad = {
	  natural_scroll = "false";
	  scroll_factor = "0.6";
	  clickfinger_behavior = "true";
        };
      };

      general = {
        gaps_in = "5";
	gaps_out = "10";
	border_size = "1";
	
	layout = "dwindle";
      };

      decoration = {
        rounding = "5";

	drop_shadow = "true";
	shadow_range = "4";
	shadow_render_power = "3";
      };

      animations = {
        enabled = "true";

	bezier = [
	  "myBezier, 0.05, 0.9, 0.1, 1.05"
	];

	animation = [
	  "windows, 1, 7, myBezier"
	  "windows, 1, 7, default, popin 80%"
	  "border, 1, 10, default"
	  "fade, 1, 7, default"
	  "workspaces, 1, 6, default"
	];
      };

      dwindle = {
        pseudotile = "true";
	preserve_split = "true";
      };

      gestures = {
        workspace_swipe = "true";
	workspace_swipe_distance = "400";
	workspace_swipe_invert = "false";
	workspace_swipe_min_speed_to_force = "0";
	workspace_swipe_cancel_ratio = "0.2";
      };

      misc = {
        disable_hyprland_logo = "true";
	vfr = "true";
      };

      windowrulev2 = [
        "suppressevent maximize, class:.*"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, Q, killactive"
	"$mod, V, togglefloating"
	"$mod, F, fullscreen"
	"$mod, D, togglesplit"

	",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
	",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
	",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"

	"$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
	
	"$mod, L, movefocus, l"
	"$mod, H, movefocus, r"
	"$mod, K, movefocus, u"
	"$mod, J, movefocus, d" 

	"$mod, mouse_down, workspace, e+1"
	"$mod, mouse_up, workspace, e-1"

	"$mod, S, togglespecialworkspace, magic"
	"$mod SHIFT, S, movetoworkspace, special:magic"
      ]
      ++ (
        builtins.concatLists (builtins.genList (
	  x: let
	    ws = let
	      c = (x + 1) / 10;
	    in
	      builtins.toString(x + 1 - (c * 10));
	  in [
	    "$mod, ${ws}, workspace, ${toString (x + 1)}"
	    "$mod SHIFt, ${ws}, movetoworkspace, ${toString (x + 1)}"
	  ]
	)
	10)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
	"$mod, mouse:273, resizewindow"
      ];
    };
  };
  };
}
