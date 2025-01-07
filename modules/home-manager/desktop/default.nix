{
  lib,
  pkgs,
  ...
}: {
  imports = lib.my.validImports ./.;

  home.packages = with pkgs; [
    swayimg
  ];
}
