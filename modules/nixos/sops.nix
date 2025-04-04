{
  config,
  lib,
  pkgs,
  settings,
  ...
}: {
  options.sops-nix.enable = lib.my.mkDefaultTrueEnableOption "sops-nix";

  config = lib.mkIf config.sops-nix.enable {
    sops = {
      defaultSopsFile = lib.my.paths.secrets + /secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/persist/home/${config.users.users.${settings.username}.name}/.config/sops/age/keys.txt";
    };
    environment.systemPackages = [pkgs.sops];
  };
}
