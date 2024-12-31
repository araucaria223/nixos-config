{
  config,
  lib,
  ...
}: {
  options.sudo.enable = lib.mkEnableOption ''
    Enable sudo
  '';

  config.security.sudo = lib.mkIf config.sudo.enable {
    enable = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults lecture="never"
    '';
  };
}
