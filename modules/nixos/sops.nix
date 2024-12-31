{
  config,
  lib,
  pkgs,
  settings,
  ...
}: {
  options.sops-nix.enable = lib.mkEnableOption ''
    Enable sops-nix
  '';

  config = lib.mkIf config.sops-nix.enable {
    sops = {
      defaultSopsFile = lib.my.paths + /secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/persist/home/${settings.username}/.config/sops/age/keys.txt";
    };
    environment.systemPackages = [pkgs.sops];
  };
}
