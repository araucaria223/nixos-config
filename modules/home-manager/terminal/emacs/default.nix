{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.unstraightened.hmModule];

  options.emacs.enable = lib.my.mkDefaultTrueEnableOption "emacs";

  config = lib.mkIf config.emacs.enable {
    programs.doom-emacs = {
      enable = true;
      doomDir = ./.;
    };

    services.emacs.enable = true;
  };
}
