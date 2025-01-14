{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lf.enable = lib.my.mkDefaultTrueEnableOption ''
    lf file manager
  '';

  config = lib.mkIf config.lf.enable {
    xdg.configFile."lf/icons".source = ./icons;

    programs.lf = {
      enable = true;

      settings = {
        preview = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };

      commands = {
        drag-out = ''%${lib.getExe pkgs.ripdrag} -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        mkdir = ''
          %{{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
      };

      keybindings = {
        m = "";
        d = "";
        "md" = "mkdir";
        ".." = "set hidden!";
        "<enter>" = "open";

        do = "drag-out";
        dd = "delete";
        dt = "cut";
        yy = "copy";
        rn = "rename";
        rl = "reload";
        C = "clear";
        U = "unselect";

        gh = "cd";
        gc = "cd /etc/nixos";
        gr = "cd /";

        ee = "editor-open";
        V = ''''$${lib.getExe pkgs.bat} --paging=always "$f""'';
      };

      extraConfig = let
        previewer = pkgs.writeShellApplication {
          name = "previewer";
          runtimeInputs = with pkgs; [file kitty pistol];
          text = ''
            file=$1
            w=$2
            h=$3
            x=$4
            y=$5

            if [[ "$( file -Lb --mime-type "$file")" =~ ^image ]]; then
              kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
            fi

            pistol "$file"
          '';
        };

        cleaner = pkgs.writeShellApplication {
          name = "clean";
          runtimeInputs = [pkgs.kitty];
          text = ''
            kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
          '';
        };
      in ''
        set cleaner ${lib.getExe cleaner}
        set previewer ${lib.getExe previewer}
      '';
    };
  };
}
