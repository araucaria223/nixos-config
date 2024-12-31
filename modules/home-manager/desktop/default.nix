{
  lib,
  pkgs,
  ...
}: {
  imports = lib.my.allNixFiles ./.;

  home.packages = with pkgs; [
    swayimg
  ];
}
# Features enabled by default
// lib.my.mapDefault true []
# Features disabled by default
// lib.my.mapDefault false []
