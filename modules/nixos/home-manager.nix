{
  config,
  lib,
  inputs,
  outputs,
  settings,
  ...
}: {
  options.homeManager.enable = lib.mkEnableOption ''
    Enable home-manager
  '';

  config.home-manager = lib.mkIf config.homeManager.enable {
    extraSpecialArgs = {inherit inputs outputs settings lib;};
    backupFileExtension = "backup";
    users = {
      "${settings.username}" = {...}: {
        imports = [
          (import ../../hosts/${settings.hostname}/home.nix)
          ../home-manager
        ];
      };
    };
  };
}
