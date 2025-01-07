{pkgs, ...}: {
  stylix.cursor = {
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-dark";
    size = 4;
  };
}
