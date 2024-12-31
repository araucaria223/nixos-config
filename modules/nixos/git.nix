{
  config,
  lib,
  settings,
  ...
}: {
  options.git.enable = lib.mkEnableOption ''
    Enable git
  '';

  config.programs.git = lib.mkIf config.git.enable {
    enable = true;
    config = {
      init.defaultBranch = "main";
      safe.directory = ["/home/${settings.username}/nixos"];

      user = {
        email = "${settings.username}@${settings.hostname}.com";
        name = "${settings.username}";
      };

      url."https://github.com/".insteadOf = [
        "gh:"
        "github:"
      ];
    };
  };
}
