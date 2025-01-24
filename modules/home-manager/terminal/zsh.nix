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
        flake = "$(readlink -f ${config.home.homeDirectory}/nixos)";

        rebTemplate = mode:
        /*
        sh
        */
        ''
          nixos-rebuild ${mode} \
            --flake ${flake}#${settings.hostname} \
            --option eval-cache false \
            |& ${lib.getExe' pkgs.nix-output-monitor "nom"} \
        '';
      in rec {
        ls = "${lib.getExe pkgs.eza} --follow-symlinks";
        lsa = "${ls} -la";
        lst = "${ls} --tree --icons";
        cat = "${lib.getExe pkgs.bat} --theme=base16";
        f = "${lib.getExe pkgs.fastfetch} --load-config examples/9.jsonc";
        less = "${pkgs.neovim}/share/nvim/runtime/macros/less.sh";
        sudo = "sudo ";

        reb = rebTemplate "switch";
        rebtest = rebTemplate "test";

        up =
          /*
          sh
          */
          ''nix flake update --flake ${flake} --commit-lock-file'';
        check =
          /*
          sh
          */
          ''nix flake check ${flake}'';
      };

      # Useful function for finding files to persist
      initExtra =
        /*
        sh
        */
        ''
          ### GENERATED ###
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
