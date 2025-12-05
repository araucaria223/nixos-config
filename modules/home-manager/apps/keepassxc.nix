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
    # Persist the password database
    home.persistence."/persist/home/${config.home.username}".directories = [
      "${config.dataDir}/passwords"
    ];

    xdg.autostart.enable = lib.mkDefault true;
    programs.keepassxc = {
      autostart = true;
      enable = true;
      settings = {
	FdoSecrets.Enabled = true;
      };
    };
  };
}
