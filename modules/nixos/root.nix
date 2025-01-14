{
  config,
  lib,
  ...
}: {
  options.root.enable = lib.my.mkDefaultTrueEnableOption "root password";

  config = lib.mkIf config.root.enable {
    sops.secrets."login/root-password" = {
      neededForUsers = true;
      sopsFile = lib.my.paths.secrets + /login.yaml;
    };
    users.users.root.hashedPasswordFile = config.sops.secrets."login/root-password".path;
  };
}
