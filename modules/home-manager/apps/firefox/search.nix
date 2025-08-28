{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox.profiles."${config.home.username}".search = lib.mkIf config.firefox.enable {
    force = true;
    default = "ddg";

    engines = let
      prms = [
        {
          name = "type";
          value = "packages";
        }
        {
          name = "query";
          value = "{searchTerms}";
        }
        {
          name = "channel";
          value = config.home.version.release;
        }
      ];

      snowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      daily = 24 * 60 * 60 * 1000;
      prefix = ".";
    in {
      # Debloating
      bing.metaData.hidden = true;
      ebay.metaData.hidden = true;

      # Alias shortening
      google.metaData.alias = "${prefix}g";
      ddg.metaData.alias = "${prefix}ddg";

      # Swiss-based privacy-focused engine
      swisscows = {
	name = "SwissCows";
        urls = [
          {
            template = "https://swisscows.com/web";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "swisscows.com/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}sc"];
      };

      # Private meta-search enging
      searxng = let
        instance = "https://searxng.site";
      in {
	name = "SearXNG";
        urls = [
          {
            template = "${instance}/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        # Pull icon from the instance
        icon = "${instance}/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}sx"];
      };

      nixos-wiki = {
	name = "NixOS Wiki";
        urls = [
          {
            template = "https://wiki.nixos.org/w/index.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = snowflake;
        definedAliases = ["${prefix}nw"];
      };

      nix-packages = {
	name = "Nix Packages";
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = prms;
          }
        ];
        icon = snowflake;
        definedAliases = ["${prefix}np"];
      };

      nixos-options = {
	name = "NixOS Options";
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = prms;
          }
        ];
        icon = snowflake;
        definedAliases = ["${prefix}no"];
      };

      # Combined packages and options search
      mynixos = {
	name = "MyNixOS";
        urls = [
          {
            template = "https://mynixos.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://mynixos.com/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}mn"];
      };

      nixpkgs-pr-tracker = {
	name = "Nixpkgs PR Tracker";
        urls = [
          {
            template = "https://nixpk.gs/pr-tracker.html";
            params = [
              {
                name = "pr";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = snowflake;
        definedAliases = ["${prefix}pr"];
      };

      # Nix API reference docs
      noogle = {
	name = "Noogle";
        urls = [
          {
            template = "https://noogle.dev/q";
            params = [
              {
                name = "term";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://noogle.dev/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}ns"];
      };

      # Nix package version search
      lazamar = {
	name = "Lazamar";
	urls = [
	  {
	    template = "lazamar.co.uk/nix-versions";
	    params = [
	      {
		name = "package";
		value = "{searchTerms}";
	      }
	      {
		name = "channel";
		value = "nixos-${config.home.version.release}";
	      }
	    ];
	  }
	];
	icon = snowflake;
	definedAliases = ["${prefix}lz"];
      };

      youtube = {
	name = "Youtube";
        urls = [
          {
            template = "https://www.youtube.com/results";
            params = [
              {
                name = "search_query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://www.youtube.com/s/desktop/060ac52e/img/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}yt"];
      };

      # Anime torrents
      nyaa = {
	name = "Nyaa";
        urls = [
          {
            template = "https://nyaa.si";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://nyaa.si/static/favicon.png";
        updateInterval = daily;
        definedAliases = ["${prefix}ny"];
      };

      nyaa-subsplease = {
	name = "Nyaa Subsplease";
        urls = [
          {
            template = "https://nyaa.si/user/subsplease";
            params = [
              {
                name = "q";
                value = "{searchTerms} 1080p";
              }
            ];
          }
        ];
        icon = "https://nyaa.si/static/favicon.png";
        updateInterval = daily;
        definedAliases = ["${prefix}sp"];
      };
    };
  };
}
