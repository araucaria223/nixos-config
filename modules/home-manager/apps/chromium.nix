{
  config,
  lib,
  pkgs,
  ...
}: {
  options.chromium.enable = lib.my.mkDefaultTrueEnableOption ''
    ungoogled chromium
  '';

  config.programs.chromium = lib.mkIf config.chromium.enable {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--enable-features=VaapiVideoDecodeLinuxGL"
      "--ignore-gpu-blocklist"
      "--enable-zero-copy"
    ];

    extensions = [
      # uBlock Origin
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
      # Youtube Sponsorblock
      "mnjggcdmjocbbbhaepdhchncahnbgone"
      # Old reddit redirect
      "dneaehbmnbhcippjikoajpoabadpodje"
      # Reddit enhancement suite
      "kbmfpngjjgdllneeigpgjifpgocmfgmb"
    ];
  };
}
