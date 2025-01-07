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
          ".config/sops/age"
          ".local/share/keyrings"
          ".local/share/direnv"
        ]
        ++ lib.my.symlink [
          "nixos"
          "media"
          "documents"
          "downloads"
        ];
      allowOther = true;
    };
  };
}
