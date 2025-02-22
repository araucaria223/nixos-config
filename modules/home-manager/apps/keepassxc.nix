{
  config,
  lib,
  pkgs,
  ...
}: {
  options.keepassxc.enable = lib.my.mkDefaultTrueEnableOption ''
    KeepassXC password manager
  '';

  config = lib.mkIf config.keepassxc.enable {
    home.persistence."/persist/home/${config.home.username}".directories = [
      "${config.configDir}/keepassxc"
      "${config.dataDir}/passwords"
    ];
    home.packages = [pkgs.keepassxc];
  };
}
