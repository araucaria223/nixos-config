{
  config,
  lib,
  ...
}: {
  programs.firefox.policies.ExtensionSettings = with builtins; let
    ext = shortId: uuid: {
      name = uuid;
      value = {
        install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
        # Prevents tampering
        installation_mode = "force_installed";
      };
    };
  in
    lib.mkIf config.firefox.enable
    (listToAttrs [
      # Adblocker
      (ext "ublock-origin" "uBlock0@raymondhill.net")
      # Skips youtube sponsored segments
      (ext "sponsorblock" "sponsorBlocker@ajay.app")
      (ext "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")

      (ext "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
      # Removes tracking from URLs
      (ext "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
      (ext "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")
      # Automatic captcha solver
      (ext "buster-captcha-solver" "{e58d3966-3d76-4cd9-8552-1582fbc800c1}")
      # Provides readable summary of most agregious terms in a ToS agreement
      (ext "terms-of-service-didnt-read" "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack")

      (ext "old-reddit-redirect" "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}")
      (ext "reddit-enhancement-suite" "jid1-xUfzOsOFlzSOXg@jetpack")

      # Password manager
      (ext "keepassxc-browser" "keepassxc-browser@keepassxc.org")
    ]);
}
