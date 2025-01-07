{pkgs, ...}: {
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 12;
      terminal = 12;
      desktop = 10;
      popups = 10;
    };
  };

  # Display foreign characters correctly
  fonts.packages = [pkgs.noto-fonts-cjk-sans];
}
