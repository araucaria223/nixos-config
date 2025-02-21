{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.spicetify.enable = lib.my.mkDefaultTrueEnableOption ''
    spicetify for spotify theming
  '';

  config = lib.mkIf config.spicetify.enable {
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        shuffle
      ];
    };

    # Save login between reboots
    home.persistence."/persist/home/${config.home.username}".directories = [
      "${config.xdg.configHome}/spotify"
      "${config.xdg.cacheHome}/spotify"
    ];
  };
}
