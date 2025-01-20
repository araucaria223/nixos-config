{config, ...}: {
  programs.firefox.policies = {
    # Updates are managed by Nix anyway
    DisableAppUpdate = true;
    ExtensionUpdate = false;

    # Directory names should be lowercase
    DefaultDownloadDirectory = "${config.home.homeDirectory}/downloads";
    DownloadDirectory = "${config.home.homeDirectory}/downloads";
    PromptForDownloadLocation = false;

    # Telemetry/privacy
    DisableFirefoxStudies = true;
    DisableTelemetry = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    SearchSuggestEnabled = false;

    # Useless features
    DisableFirefoxAccounts = true;
    DisableAccounts = true;
    DisablePocket = true;
    DisableProfileImport = true;

    # It wouldn't work anyway
    DisableSetDesktopBackground = true;
    # I can take my own screenshots
    DisableFirefoxScreenshots = true;
    # Takes up screen space, ugly
    DisplayBookmarksToolbar = "never";

    # Firefox is not a password manager
    DisableMasterPasswordCreation = true;
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;

    # Why do you care?
    DontCheckDefaultBrowser = true;

    # Get rid of annoying page on first run
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";

    Preferences = let
      lock = value: {
        Value = value;
        Status = "locked";
      };
    in {
      "browser.contentblocking.category" = lock "strict";
      "browser.sessionstore.resume_from_crash" = lock true;
      "browser.aboutConfig.showWarning" = lock false;

      # Stupid and annoying
      "extensions.pocket.enabled" = lock false;
      "extensions.screenshots.disabled" = lock false;
      "browser.topsites.contile.enabled" = lock false;
      "browser.formfill.enable" = lock false;
      # Privacy
      "browser.search.suggest.enabled" = lock false;
      "browser.search.suggest.enabled.private" = lock false;
      "browser.urlbar.suggest.searches" = lock false;
      "browser.urlbar.showSearchSuggestionsFirst" = lock false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = lock false;
      "browser.newtabpage.activity-stream.feeds.snippets" = lock false;
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock false;
      "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock false;
      "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock false;
      "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock false;
      "browser.newtabpage.activity-stream.showSponsored" = lock false;
      "browser.newtabpage.activity-stream.system.showSponsored" = lock false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock false;
    };
  };
}
