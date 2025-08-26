{...}: {
  imports = [./hardware-configuration.nix];

  #hardware.bluetooth.enable = true;
  bluetooth.enable = true;
  fprintd.enable = true;

  sddm.enable = false;
  greetd.enable = true;

  systemd-boot.enable = false;
  lanzaboote.enable = true;

  system.stateVersion = "24.11";
}
