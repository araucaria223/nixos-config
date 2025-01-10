{
  pkgs,
  lib,
  ...
}: {
  vim = {
    theme = {
      enable = true;
      name = "rose-pine";
      style = "main";
    };

    languages = {
      enableLSP = true;
      enableTreesitter = true;
      nix.enable = true;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
  };
}
