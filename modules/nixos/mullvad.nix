{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mullvad.enable = lib.my.mkDefaultTrueEnableOption ''
    mullvad vpn
  '';

  config.services = lib.mkIf config.mullvad.enable {
    resolved.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
