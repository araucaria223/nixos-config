{
  config,
  lib,
  pkgs,
  ...
}: {
  options.minecraft.enable = lib.my.mkDefaultTrueEnableOption ''
    Prism launcher for minecraft
  '';

  config.home = lib.mkIf config.minecraft.enable {
    packages = [pkgs.prismlauncher];

    persistence."/persist/home/${config.home.username}".directories = [
      ".local/share/PrismLauncher"
    ];
  };
}
