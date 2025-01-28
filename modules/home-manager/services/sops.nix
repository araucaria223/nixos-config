{
  config,
  lib,
  ...
}: {
  options.sops-nix.enable = lib.my.mkDefaultTrueEnableOption ''
    sops-nix for secrets management
  '';

  config.sops = lib.mkIf config.sops-nix.enable {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = lib.my.paths.secrets + /secrets.yaml;
  };
}
