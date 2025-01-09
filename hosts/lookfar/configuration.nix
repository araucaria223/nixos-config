{...}: {
  imports = [./hardware-configuration.nix];

  hardware.bluetooth.enable = true;

  system.stateVersion = "24.11";

  homeManager.enable = false;
}
