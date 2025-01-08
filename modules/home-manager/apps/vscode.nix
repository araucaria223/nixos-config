{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.vscode.enable = lib.mkDefaultTrueEnableOption ''
    Visual Studio Code (vscodium)
  '';

  config = lib.mkif config.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
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
      };
    };
  };
}
