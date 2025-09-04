{
  config,
  lib,
  pkgs,
  settings,
  ...
}: {
  options.mainUser.enable = lib.my.mkDefaultTrueEnableOption "main user";

  config = lib.mkIf config.mainUser.enable {
    sops.secrets = {
      "login/${settings.username}-password" = {
        neededForUsers = true;
        sopsFile = lib.my.paths.secrets + /login.yaml;
      };

      "login/root-password" = {
        neededForUsers = true;
        sopsFile = lib.my.paths.secrets + /login.yaml;
      };
    };

    users.users = {
      root.hashedPasswordFile = config.sops.secrets."login/root-password".path;

      ${settings.username} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPasswordFile = config.sops.secrets."login/${settings.username}-password".path;
        # initialPassword = "password";
        shell = lib.mkIf config.programs.zsh.enable pkgs.zsh;
      };
    };
  };
}
