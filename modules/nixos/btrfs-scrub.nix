{
  config,
  lib,
  ...
}: {
  options.btrfs-scrub.enable = lib.mkEnableOption ''
    Enable btrfs autoscrubbing
  '';

  config.services.btrfs.autoScrub = lib.mkIf config.btrfs-scrub.enable {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/persist"
      "/nix"
      "/"
    ];
  };
}
