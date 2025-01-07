{
  config,
  pkgs,
  ...
}: {
  programs.firefox.profiles."${config.home.username}".search = {
    force = true;
    default = "Duckduckgo";

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
      Bing.metaData.hidden = true;
      eBay.metaData.hidden = true;

      # Alias shortening
      Google.metaData.alias = "${prefix}g";
      DuckDuckGo.metaData.alias = "${prefix}ddg";

      # Swiss-based privacy-focused engine
      Swisscows = {
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
        iconUpdateURL = "swisscows.com/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}sc"];
      };

      # Private meta-search enging
      SearXNG = let
        instance = "https://searxng.site";
      in {
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
        iconUpdateURL = "${instance}/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}sx"];
      };

      "Nix Packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = prms;
          }
        ];
        icon = snowflake;
        definedAliases = ["${prefix}np"];
      };

      "NixOS Options" = {
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
      "MyNixOS Search" = {
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
        iconUpdateURL = "https://mynixos.com/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}mn"];
      };

      "Nixpkgs PR Tracker" = {
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
      "Noogle Search" = {
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
        iconUpdateURL = "https://noogle.dev/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}ns"];
      };

      "Youtube Search" = {
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
        iconUpdateURL = "https://www.youtube.com/s/desktop/060ac52e/img/favicon.ico";
        updateInterval = daily;
        definedAliases = ["${prefix}yt"];
      };

      # Anime torrents
      "NyaaSi Search" = {
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
        iconUpdateURL = "https://nyaa.si/static/favicon.png";
        updateInterval = daily;
        definedAliases = ["${prefix}ny"];
      };

      "NyaaSi Subsplease Search" = {
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
        iconUpdateURL = "https://nyaa.si/static/favicon.png";
        updateInterval = daily;
        definedAliases = ["${prefix}sp"];
      };
    };
  };
}
