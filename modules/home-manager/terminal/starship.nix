{
  config,
  lib,
  ...
}: let
  cfg = config.starship;

  inherit (builtins) map;
  inherit (lib.strings) concatStrings;
in {
  options.starship = {
    enable = lib.mkEnableOption ''
           Enable starship -
      a minimal and customisable shell prompt
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.starship = let
      elemsConcatted = concatStrings (
        map (s: "\$${s}") [
          "hostname"
          "username"
          "directory"
          "shell"
          "nix_shell"
          "git_branch"
          "git_commit"
          "git_state"
          "git_status"
          "jobs"
          "cmd_duration"
        ]
      );
    in {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        line_break.disabled = false;

        format = "${elemsConcatted}\n$character";

        hostname = {
          ssh_only = true;
          disabled = false;
          format = "@[$hostname](bold blue) ";
        };

        username.format = "[$user]($style) in ";

        character = {
          error_symbol = "[](bold red)";
          success_symbol = "[](bold green)";
          vicmd_symbol = "[](bold yellow)";
          format = "$symbol [|](bold bright-black) ";
        };

        directory = {
          truncation_length = 2;
          format = "[ ](bold green) [$path]($style) ";
          # substitutions = {
          #   "~/loads" = "loads";
          #   "~/docs" = "docs";
          # };
        };

        git_commit.commit_hash_length = 7;
        git_branch.style = "bold purple";
        git_status = {
          style = "red";
          ahead = "⇡ ";
          behind = "⇣ ";
          conflicted = " ";
          renamed = "»";
          deleted = "✘ ";
          diverged = "⇆ ";
          modified = "!";
          stashed = "≡";
          staged = "+";
          untracked = "?";
        };

        lua.symbol = "[ ](blue) ";
        python.symbol = "[ ](blue) ";
        rust.symbol = "[ ](red) ";
        nix_shell.symbol = "[󱄅 ](blue) ";
        golang.symbol = "[󰟓 ](blue)";
        c.symbol = "[ ](black)";
        nodejs.symbol = "[󰎙 ](yellow)";

        package.symbol = "📦 ";
      };
    };
  };
}
