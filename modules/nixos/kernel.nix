{
  config,
  lib,
  pkgs,
  ...
}: {
  options.kernel-patches.enable = lib.my.mkDefaultTrueEnableOption ''
    custom kernel patches
  '';

  config = lib.mkIf config.kernel-patches.enable {
    # Use latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Add kernel patches here
  };
}
