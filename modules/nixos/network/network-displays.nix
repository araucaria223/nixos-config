{
  config,
  lib,
  pkgs,
  ...
}: {
  options.network-displays.enable = lib.my.mkDefaultTrueEnableOption ''
    gnome network displays
  '';

  config = lib.mkIf config.network-displays.enable {
    environment.systemPackages = [
      pkgs.gnome-network-displays
    ];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-wlr
      ];
    };
    networking.firewall.trustedInterfaces = ["p2p-wl+"];
    networking.firewall.allowedTCPPorts = [7236 7250];
    networking.firewall.allowedUDPPorts = [7236 5353];
  };
}
