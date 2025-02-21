{
  pkgs,
  lib,
  ...
}: {
  imports = lib.my.validImports ./.;

  home.packages = with pkgs; [
    # Torrent client
    qbittorrent
    # GUI file manager
    pcmanfm
  ];

  programs.neovide = lib.mkDefault {
    enable = true;
    settings = {
      font.size = 7.0;
    };
  };

  # Set default applications
  xdg.mimeApps = lib.mkDefault rec {
    enable = true;
    defaultApplications = let
      browser = ["firefox.desktop"];
    in {
      "application/pdf" = ["org.pwmt.zathura.desktop"];

      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;

      "inode/directory" = ["pcmanfm.desktop"];
    };

    associations.added = defaultApplications;
  };
}
