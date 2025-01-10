{...}: {
  imports = [./hardware-configuration.nix];

  hardware.bluetooth.enable = true;
  fprintd.enable = true;

  system.stateVersion = "24.11";
}
