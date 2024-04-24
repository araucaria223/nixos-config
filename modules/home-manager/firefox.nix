{ config, pkgs, inputs, lib, ... }:

{
  options = {
    firefox.userConfig = lib.mkEnableOption "enable firefox user configuration";
  };

  config = lib.mkIf config.firefox.userConfig {
  programs.firefox = {
    enable = true;

    profiles.adzuki = {
      settings = {
        "dom.security.https_only_mode" = true;

	"signon.rememberSignons" = false;
	"widget.use-xdg-desktop-portal.file-picker" = 1;
	"browser.aboutConfig.showWarning" = false;
	"widget.disable-workspace-management" = true;
	"browser.toolbars.bookmarks.visibility" = "never";
      };

      bookmarks = [
        {
	  name = "Wiki";
	  tags = [ "wiki" "nix" ];
	  url = "https://nixos.wiki";
	}
      ];


      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        tabliss
	disable-javascript
	sponsorblock
	youtube-shorts-block
	old-reddit-redirect
	reddit-enhancement-suite
      ];

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };
      search.force = true;

    };
  };
  };
}
