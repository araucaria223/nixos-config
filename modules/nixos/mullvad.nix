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
      key = "";
    };

    environment.etc."mullvad-vpn/device.json".source = config.sops.secrets.mullvad-device.path;
    systemd.services."mullvad-daemon".postStart = let
      mullvad = lib.getExe' config.services.mullvad-vpn.package "mullvad";
    in /*sh*/ ''
      while ! ${mullvad} status >/dev/null; do sleep 1; done
      ${mullvad} connect
      ${mullvad} dns set default --block-ads --block-trackers --block-malware
      ${mullvad} tunnel set wireguard --daita on
    '';
  };
}
