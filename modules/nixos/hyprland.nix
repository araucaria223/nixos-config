{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.hyprland.enable = lib.my.mkDefaultTrueEnableOption "hyprland";

  config = lib.mkIf config.hyprland.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Enable the hyprland binary cache
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    programs.hyprland = let
      hyprPackages = inputs.hyprland.packages.${pkgs.system};
    in {
      enable = true;
      # Use the package provided by the flake
      #package = hyprPackages.hyprland;
      #portalPackage = hyprPackages.xdg-desktop-portal-hyprland;
    };
  };
}
