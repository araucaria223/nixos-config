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
    # GUI file manager
    pcmanfm
  ];

  # Set default applications
  xdg.mimeApps = lib.mkDefault rec {
    enable = true;
    defaultApplications = let
      browser = ["firefox.desktop"];
    in {
      "application/pdf" = ["zathura.desktop"];

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
