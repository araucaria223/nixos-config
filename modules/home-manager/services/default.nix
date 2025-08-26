{lib, ...}: {
  imports = lib.my.validImports ./.;

  # Enable mpris-proxy for bluetooth media controls
  services.mpris-proxy.enable = lib.mkDefault true;
}
