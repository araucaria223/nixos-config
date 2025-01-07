{
  pkgs,
  lib,
  ...
}: {
  imports = lib.my.validImports ./.;

  home.packages = with pkgs; [
    # Password manager
    keepassxc
    # Torrent client
    qbittorrent
  ];
}
