{
  config,
  lib,
  ...
}: {
  options.root.enable = lib.my.mkDefaultTrueEnableOption "root password";

  config = lib.mkIf config.root.enable {
    sops.secrets."root-password" = {
      neededForUsers = true;
      sopsFile = lib.my.paths.secrets + /login.yaml;
    };
    users.users.root.hashedPasswordFile = config.sops.secrets."root-password".path;
  };
}
