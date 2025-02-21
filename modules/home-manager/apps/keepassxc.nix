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
    home.persistence."/persist/home/${config.home.username}".directories = ["${config.xdg.configHome}/keepassxc"];
    home.packages = [pkgs.keepassxc];
  };
}
