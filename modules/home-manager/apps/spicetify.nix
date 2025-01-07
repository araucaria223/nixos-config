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

  options.spiectify.enable = lib.my.mkDefaultTrueEnableOption ''
    spicetify for spotify theming
  '';

  config.programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in
    lib.mkIf config.spicetify.enable {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        shuffle
      ];
    };
}
