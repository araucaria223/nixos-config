{...}: {
  imports = [./hardware-configuration.nix];

  hardware.bluetooth.enable = true;
  fprintd.enable = true;

  sddm.enable = false;
  greetd.enable = true;

  system.stateVersion = "24.11";
}
