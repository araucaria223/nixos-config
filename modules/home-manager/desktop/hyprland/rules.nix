{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = lib.mkIf config.hyprland.enable {
    windowrulev2 = [
      # Prevent apps from launching maximised
      "suppressevent maximise, class:.*"

      # Calculator is launched floating in scratchpad
      "float, class:(qalculate-gtk)"
      "workspace special:calculator, class:(qalculate-gtk)"

      # KeePassXC is launched floating in scratchpad
      "float, class:(org.keepassxc.KeePassXC)"
      "size >50%, class:(org.keepassxc.KeePassXC)"
      "workspace special:password, class:(org.keepassxc.KeePassXC)"

      # Mullvad launched in scratchpad
      "workspace special:vpn, class:(Mullvad VPN)"
    ];

    workspace = [
      # Launch apps in scratchpads when they are created empty
      "special:system, on-created-empty:${lib.getExe pkgs.kitty} -e ${lib.getExe pkgs.bottom}"
      "special:calculator, on-created-empty:${lib.getExe pkgs.qalculate-gtk}"
      "special:password, on-created-empty:${lib.getExe pkgs.keepassxc}"
      "special:vpn, on-created-empty:${lib.getExe' pkgs.mullvad-vpn "mullvad-vpn"}"
    ];

    exec-once = [
      "[workspace special:system silent] ${lib.getExe pkgs.kitty} -e ${lib.getExe pkgs.bottom}"
      "[workspace special:password silent] ${lib.getExe pkgs.keepassxc}"
      (lib.getExe pkgs.waybar)
    ];
  };
}
