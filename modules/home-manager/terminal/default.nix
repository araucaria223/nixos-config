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

  # Youtube downloader
  programs.yt-dlp.enable = lib.mkDefault true;
  # System info
  programs.bottom.enable = lib.mkDefault true;

  # Direnv
  programs.direnv = lib.mkDefault {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
