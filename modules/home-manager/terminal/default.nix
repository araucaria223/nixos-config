{
  lib,
  pkgs,
  ...
}: {
  imports = lib.my.validImports ./.;

  home.packages = with pkgs; [
    # Disk usage analytics
    ncdu
  ];

  # Fuzzy finder
  programs.fzf = lib.mkDefault {
    enable = true;
    enableZshIntegration = true;
  };
}
# Features enabled by default
// lib.my.mapDefault true [
  # Youtube downloader
  "programs.yt-dlp"
  "programs.bottom"

  # Terminals
  "alacritty"
  "kitty"
]
# Features disabled by default
// lib.my.mapDefault false []
