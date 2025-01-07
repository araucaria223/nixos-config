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
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
             file=$1
             w=$2
             h=$3
             x=$4
             y=$5

             if [[ "$( ${lib.getExe pkgs.file} -Lb --mime-type "$file")" =~ ^image ]]; then
          ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
          exit 1
             fi

             ${lib.getExe pkgs.pistol} "$file"
        '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${lib.getExe pkgs.kitty} +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
    };
  };
}
