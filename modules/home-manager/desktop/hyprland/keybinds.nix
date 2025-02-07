{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = lib.mkIf config.hyprland.enable {
    settings = {
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

      # Non-consuming, passed to active window as well
      bindn = let
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
      in [
        # Use escape to exit any special workspace
        ", Escape, exec, ${lib.getExe exit-special-workspace}"
      ];

      bind = let
        pctl = lib.getExe pkgs.playerctl;
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

          # Enter fast edit mode
          "$mod, A, submap, fastedit"

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
          "$mod SHIFT, C, exec, ${lib.getExe pkgs.hyprpicker} --autocopy"
          # Screenshot
          "$mod SHIFT, S, exec, ${lib.getExe pkgs.my.screenshot}"
          # Lock screen
          "$mod SHIFT, L, exec, pgrep hyprlock || ${lib.getExe pkgs.hyprlock}"
          # Reload wifi
          "$mod, R, exec, wpa_cli reconnect"

          # Scratchpads
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

    # Submaps are not properly implemented in the home-manager module yet
    extraConfig = let
      submaps = {
        fastedit = {
          settings = {
            binde = [
              ", h, resizeactive, -10 0"
              ", j, resizeactive, 0 10"
              ", k, resizeactive, 0 -10"
              ", l, resizeactive, 10 0"
            ];

            bind = [
              ", left, movefocus, l"
              ", right, movefocus, r"
              ", up, movefocus, u"
              ", down, movefocus, d "
            ];

            bindm = [
              ", mouse:272, movewindow"
            ];
          };

          extraConfig = ''
	    bind = , catchall, submap, reset
	  '';
	};
      };
    in
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList
        (name: submap: (
          "submap = ${name}\n"
          + lib.optionalString (submap.settings != {}) (
            inputs.home-manager.lib.hm.generators.toHyprconf {
              attrs = submap.settings;
            }
          )
          + lib.optionalString (submap.extraConfig != "") submap.extraConfig
          + "submap = reset"
        ))
        submaps
      );
  };
}
