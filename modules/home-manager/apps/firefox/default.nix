{
  config,
  lib,
  ...
}: {
  imports = lib.my.validImports ./.;

  options.firefox.enable = lib.my.mkDefaultTrueEnableOption "firefox";

  config = lib.mkIf config.firefox.enable {
    # Persist firefox's data
    home.persistence."/persist/home/${config.home.username}".directories = [".mozilla"];

    stylix.targets.firefox.profileNames = [config.home.username];

    programs.firefox = {
      enable = true;

      # Set up profile for user
      profiles."${config.home.username}" = {
        settings = {
          # Show a blank page on startup
          "browser.startup.homepage" = "about:newtab";
        };

        bookmarks = {
          force = true;
          settings = [
            {
              name = "NixOS Wiki";
              tags = ["wiki" "nix"];
              url = "https://wiki.nixos.org";
            }
          ];
        };
      };
    };
  };
}
