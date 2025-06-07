{
  config,
  lib,
  ...
}: {
  imports = lib.my.validImports ./.;

  options.floorp.enable = lib.mkEnableOption "floorp";

  config = lib.mkIf config.floorp.enable {
    # Persist floorp's data
    home.persistence."/persist/home/${config.home.username}".directories = [".floorp"];

    # Target HM-managed profile for styling
    stylix.targets.floorp.profileNames = [config.home.username];

    programs.floorp = {
      enable = true;

      # Set up user profile
      profiles."${config.home.username}" = {
	settings = {
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
