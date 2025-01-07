{
  config,
  lib,
  ...
}: {
  options.fprintd.enable = lib.my.mkDefaultTrueEnableOption ''
    fingerprint scanner for login
  '';

  config = lib.mkIf config.fprintd.enable {
    services.fprintd.enable = true;
    security.pam.services.login.fprintAuth = true;
  };
}
