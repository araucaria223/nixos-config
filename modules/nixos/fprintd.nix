{
  config,
  lib,
  ...
}: {
  options.fprintd.enable = lib.mkEnableOption ''
    Enable fingerprint scanner for login
  '';

  config = lib.mkIf config.fprintd.enable {
    services.fprintd.enable = true;
    security.pam.services.login.fprintAuth = true;
  };
}
