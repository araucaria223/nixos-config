{
  config,
  lib,
  ...
}: {
  options.impermanence.enable = lib.my.mkDefaultTrueEnableOption ''
    home impermanence
  '';

  config.home.persistence = lib.mkIf config.impermanence.enable {
    "/persist/home/${config.home.username}" = {
      directories =
        [
          ".ssh"
          ".pki"
          "${config.configDir}/sops/age"
          "${config.dataDir}/keyrings"
          "${config.dataDir}/direnv"
        ]
        ++ lib.my.symlink [
          "nixos"
          "media"
          "documents"
          "downloads"
          "code"
        ];
      allowOther = true;
    };
  };
}
