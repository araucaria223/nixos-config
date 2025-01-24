{
  config,
  lib,
  ...
}: {
  options.fprintd.enable = lib.mkEnableOption ''
    fingerprint scanner for login
  '';

  config = lib.mkIf config.fprintd.enable {
    services.fprintd.enable = true;
    security.pam.services.login.fprintAuth = true;

    # Persist fingerprints
    environment.persistence."/persist/system".directories = [
      {
        directory = "/var/lib/fprint";
        mode = "700";
      }
    ];
  };
}
