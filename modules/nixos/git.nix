{
  config,
  lib,
  settings,
  ...
}: {
  options.git.enable = lib.my.mkDefaultTrueEnableOption "git";

  config.programs.git = lib.mkIf config.git.enable {
    enable = true;
    config = let
      username = config.users.users.${settings.username}.name;
      hostname = config.networking.hostName;
    in {
      init.defaultBranch = "main";
      safe.directory = ["/home/${username}/nixos"];

      user = {
        email = "${username}@${hostname}";
        name = username;
      };

      url."https://github.com/".insteadOf = [
        "gh:"
        "github:"
      ];
    };
  };
}
