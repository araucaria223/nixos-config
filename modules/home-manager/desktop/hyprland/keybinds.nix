{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = lib.mkIf config.hyprland.enable {
    "$mod" = "SUPER";

    # Mouse binds
    bindm = [
      # $mod+left-click to drag windows around
      "$mod, mouse:272, movewindow"
      # $mod+right-click to resize windows
      "$mod, mouse:273, resizewindow"
    ];

    # Repeat if held
    binde = let
      pamixer = lib.getExe pkgs.pamixer;
      bctl = lib.getExe pkgs.brightnessctl;
    in [
      # Volume controls
      ",XF86AudioRaiseVolume, exec, ${pamixer} -i 5"
      ",XF86AudioLowerVolume, exec, ${pamixer} -d 5"
      ",XF86AudioMute, exec, ${pamixer} --toggle-mute"

      # Brightness controls
      ",XF86MonBrightnessUp, exec, ${bctl} s +5%"
      ",XF86MonBrightnessDown, exec, ${bctl} s 5%-"
      # Use control for more granular adjustment
      "CTRL,XF86MonBrightnessUp, exec, ${bctl} s +1%"
      "CTRL,XF86MonBrightnessDown, exec, ${bctl} s 1%-"
    ];

    bind = let
      pctl = lib.getExe pkgs.playerctl;
      hyprpicker = "${lib.getExe pkgs.hyprpicker} --autocopy";

      screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [grim slurp swappy];
        text = ''pgrep slurp || grim -g "$(slurp)" - | swappy -f'';
      };

      exit-special-workspace = pkgs.writeShellApplication {
	name = "exit-special-workspace";
	runtimeInputs = [pkgs.jq];
	text = ''
	  ws=$( \
	    hyprctl -j monitors \
	    | jq '[.[]|.specialWorkspace.name][0]' \
	    | tr -d '"' | cut -d ':' -f 2 \
	  )
	  if [[ -n "$ws" ]]; then
	    hyprctl dispatch togglespecialworkspace "$ws"
	  fi
	'';
      };
    in
      [
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

        # Change focused window
        "$mod, H, movefocus, r"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, l"

        # Media keys
        ",XF86AudioPlay, exec, ${pctl} play-pause"
        ",XF86AudioNext, exec, ${pctl} next"
        ",XF86AudioPrev, exec, ${pctl} previous"

        # Terminal
        "$mod, Return, exec, ${lib.getExe pkgs.kitty}"
        # Application launcher
        "$mod, Space, exec, pgrep fuzzel || ${lib.getExe pkgs.fuzzel}"
        # Emoji search
        "$mod SHIFT, E, exec, pgrep fuzzel || ${lib.getExe pkgs.bemoji}"
        # Color picker
        "$mod SHIFT, C, exec, ${hyprpicker}"
        # Screenshot
        "$mod SHIFT, S, exec, ${lib.getExe screenshot}"
        # Lock screen
        "$mod SHIFT, L, exec, pgrep hyprlock || ${lib.getExe pkgs.hyprlock}"
        # Reload wifi
        "$mod, R, exec, wpa_cli reconnect"

        # Scratchpads
	"$mod, Escape, exec, ${lib.getExe exit-special-workspace}"
        "$mod, I, togglespecialworkspace, system"
        "$mod, C, togglespecialworkspace, calculator"
        "$mod, P, togglespecialworkspace, password"
        "$mod SHIFT, V, togglespecialworkspace, vpn"

        # Scroll workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      # Numbered binds for workspaces 1-10
      ++ lib.concatMap (x: let
        key = toString (lib.mod x 10);
        wksp = toString x;
      in [
        "$mod, ${key}, workspace, ${wksp}"
        "$mod SHIFT, ${key}, movetoworkspace, ${wksp}"
      ]) (lib.range 1 10);
  };
}
