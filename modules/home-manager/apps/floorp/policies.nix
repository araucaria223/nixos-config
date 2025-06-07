{
  config,
  lib,
  ...
}: {
  programs.floorp.policies = lib.mkIf config.floorp.enable rec {
    # Updates are managed by Nix anyway
    DisableAppUpdate = true;
    ExtensionUpdate = false;

    # Directory names should be lowercase
    DefaultDownloadDirectory = "${config.home.homeDirectory}/downloads";
    DownloadDirectory = DefaultDownloadDirectory;
    PromptForDownloadLocation = false;

    # Telemetry
    DisableTelemetry = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    SearchSuggestEnabled = false;

    # Useless features
    DisableAccounts = true;

    # It wouldn't work anyway
    DisableSetDesktopBackground = true;
    DisplayBookmarksToolbar = "never";

    DisableMasterPasswordCreation = true;
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;

    # Why do you care?
    DontCheckDefaultBrowser = true;

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
    };
  };
}
