{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mullvad.enable = lib.my.mkDefaultTrueEnableOption ''
    mullvad vpn
  '';

  config = lib.mkIf config.mullvad.enable {
    services = {
      resolved.enable = true;
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };

    sops.secrets.mullvad-device = {
      format = "json";
      sopsFile = lib.my.paths.secrets + /network/mullvad.json;
      # Read the entire sops file, do not extract values
      key = "";
    };

    environment.etc."mullvad-vpn/device.json".source = config.sops.secrets.mullvad-device.path;
    systemd.services."mullvad-daemon".postStart = let
      mullvad = lib.getExe' config.services.mullvad-vpn.package "mullvad";
    in
      # sh
      ''
        while ! ${mullvad} status >/dev/null; do sleep 1; done
        ${mullvad} connect
        ${mullvad} dns set default --block-ads --block-trackers --block-malware
        ${mullvad} tunnel set wireguard --daita on
      '';

    # Allow geoclue to connect to endpoint without VPN
    networking.nftables = {
      enable = true;
      tables = {
        excludeTraffic = {
          content = ''
            chain excludeOutgoing {
              type route hook output priority 0; policy accept;
              ip daddr 89.58.44.75 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            }
          '';
          family = "inet";
        };
      };
    };
  };
}
