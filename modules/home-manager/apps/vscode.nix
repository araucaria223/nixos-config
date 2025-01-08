{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  options.vscode.enable = lib.my.mkDefaultTrueEnableOption ''
    VSCode integrated development environment
  '';

  config = lib.mkIf config.vscode.enable {
    # Disable stylix' base16 theme
    stylix.targets.vscode.enable = false;
    home.packages = [pkgs.nixd];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with inputs.nix-vscode-extensions.${pkgs.system}.vscode-marketplace; [
        vscodevim.vim
        yzhang.markdown-all-in-one
        mvllow.rose-pine
        jnoortheen.nix-ide
        esbenp.prettier-vscode
      ];

      userSettings = {
        workbench.colorTheme = "Rosé Pine";
        editor.defaultFormatter = "esbenp.prettier-vscode";
        editor.formatOnSave = true;
        nix = {
          serverPath = lib.getExe pkgs.nixd;
          formatterPath = lib.getExe outputs.formatter.${pkgs.system};
        };
      };
    };
  };
}
