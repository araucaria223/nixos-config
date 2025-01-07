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

  programs.yt-dlp.enable = lib.mkDefault true;
  programs.bottom.enable = lib.mkDefault true;
}
# Features enabled by default
// lib.my.mapDefault true [
  # Terminals
  "alacritty"
  "kitty"
]
# Features disabled by default
// lib.my.mapDefault false []
