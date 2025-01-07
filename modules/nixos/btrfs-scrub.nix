{
  config,
  lib,
  ...
}: {
  options.btrfs-scrub.enable = lib.my.mkDefaultTrueEnableOption ''
    btrfs autoscrubbing
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
