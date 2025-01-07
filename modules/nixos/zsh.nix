{
  config,
  lib,
  ...
}: {
  options.zsh.enable = lib.my.mkDefaultTrueEnableOption "zsh";

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
