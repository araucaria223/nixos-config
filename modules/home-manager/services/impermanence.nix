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
          "${config.xdg.configHome}/sops/age"
          "${config.xdg.dataHome}/keyrings"
          "${config.xdg.dataHome}/direnv"
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
