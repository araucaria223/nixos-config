{
  lib,
  pkgs,
  ...
}: {
  imports = lib.my.allNixFiles ./.;

  home.packages = with pkgs; [
    # Disk usage analytics
    ncdu
  ];

  # Youtube downloader
  programs.yt-dlp.enable = true;
}
# Features enabled by default
// lib.my.mapDefault true [
  "alacritty"
]
# Features disabled by default
// lib.my.mapDefault false []
