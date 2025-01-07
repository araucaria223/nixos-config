{
  config,
  lib,
  ...
}: {
  options.sudo.enable = lib.my.mkDefaultTrueEnableOption ''
    sudo
  '';

  config.security.sudo = lib.mkIf config.sudo.enable {
    enable = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults lecture="never"
    '';
  };
}
