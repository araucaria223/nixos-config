{
  config,
  lib,
  pkgs,
  settings,
  ...
}: let
  cfg = config.zsh;
in {
  options.zsh = {
    enable = lib.my.mkDefaultTrueEnableOption ''
      zsh - the z shell
    '';
  };

  config = lib.mkIf cfg.enable {
    # Persist zsh history
    home.persistence."/persist/home/${config.home.username}".files = ["${config.xdg.dataHome}/zsh/history"];

    programs.zsh = {
      enable = true;

      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";

      shellAliases = let
        eza = "${lib.getExe pkgs.eza} --follow-symlinks";
        bat = lib.getExe pkgs.bat;
        fastfetch = lib.getExe pkgs.fastfetch;
	flake = "$(readlink -f ${config.home.homeDirectory}/nixos)";

        git = "${lib.getExe pkgs.git} -C ${flake}";

	rebTemplate = mode: /*sh*/ ''
	  nixos-rebuild ${mode} \
	    --flake ${flake}#${settings.hostname} \
	    --option eval-cache false \
	    |& ${lib.getExe' pkgs.nix-output-monitor "nom"} \
	'';

      in rec {
        ls = "${eza}";
        lsa = "${eza} -la";
        lst = "${eza} --tree --icons";
        cat = "${bat} --theme=base16";
        f = "${fastfetch} --load-config examples/9.jsonc";
        less = "${pkgs.neovim}/share/nvim/runtime/macros/less.sh";
	sudo = "sudo ";

        reb = rebTemplate "switch" ;
	rebtest = rebTemplate "test";

        up = /*sh*/ "nix flake update --flake ${flake} --commit-lock-file";
      };

      initExtra =
        /*
        sh
        */
        ''
          function fsdiff {
	    fd \
            --one-file-system \
            --base-directory / \
            --type f \
            --hidden \
            --exclude "{tmp,etc/passwd,${config.home.homeDirectory}/.cache/mozilla,$1}" \
            | ${config.programs.zsh.shellAliases.less}
          }
        '';
    };
  };
}
