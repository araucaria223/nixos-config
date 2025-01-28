{
  config,
  lib,
  inputs,
  outputs,
  settings,
  ...
}: {
  options.homeManager.enable = lib.my.mkDefaultTrueEnableOption "home-manager";

  config.home-manager = lib.mkIf config.homeManager.enable {
    extraSpecialArgs = {inherit inputs outputs settings lib;};
    backupFileExtension = "backup";
    users = {
      "${config.users.users."${settings.username}".name}" = {...}: {
        imports = [
          (import ../../hosts/${settings.hostname}/home.nix)
          ../home-manager
	  inputs.sops-nix.homeManagerModules.sops
        ];
      };
    };
  };
}
