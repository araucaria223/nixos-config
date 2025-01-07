{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  keyDir = "/var/lib/sbctl";
in {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.lanzaboote.enable = lib.mkEnableOption ''
    lanzaboote for secure boot
  '';

  config = lib.mkIf config.lanzaboote.enable {
    environment = {
      # For debugging and troubleshooting
      systemPackages = [pkgs.sbctl];
      # Persist secure boot keys
      persistence."/persist/system".directories = [keyDir];
    };

    boot = {
      # Lanzaboote replaces the systemd-boot module
      # So ensure systemd-boot is disabled
      loader.systemd-boot.enable = lib.mkForce false;

      lanzaboote = {
        enable = true;
        # Keys need to be found before impermanence mounts
        # /persist/system${keyDir} to ${keyDir}
        pkiBundle = "/persist/system${keyDir}";
      };
    };
  };
}
