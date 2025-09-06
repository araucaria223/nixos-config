{
  config,
  lib,
  inputs,
  outputs,
  settings,
  ...
}: {
  imports = lib.my.validImports ./.
    ++ [inputs.nix-sweep.nixosModules.default];

  # Static options
  networking.hostName = settings.hostname;
  i18n.defaultLocale = "en_GB.UTF-8";

  # Firmware updates
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;

  # Dynamic options
  security.pam.services.hyprlock.fprintAuth = lib.mkDefault true;
  # Global styling
  stylix.enable = lib.mkDefault true;

  # Set machine ID
  sops.secrets."machine-id/${config.networking.hostName}" = {
    sopsFile = lib.my.paths.secrets + /machine-id.yaml;
    mode = "0664";
  };

  environment.etc.machine-id.source = config.sops.secrets."machine-id/${config.networking.hostName}".path;

  # Nix/Nixpkgs modifications
  nixpkgs = {
    overlays = with outputs.overlays; [
      additions
      modifications
      unstable-packages
    ];

    # Allow unfree packages
    config.allowUnfree = true;
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = [
        # Enable flakes
        "nix-command"
        "flakes"
        # Pipe operator |>
        "pipe-operators"
      ];

      # Disable global registry
      flake-registry = "";
      # Optimise the nix store on rebuild
      auto-optimise-store = true;

      # Use the nix community binary cache
      substituters = ["https://nix-community.cachix.org"];
      trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
    };

    # Disable channels
    channel.enable = false;

    # Make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    # Enable automatic garbage collection of generations older than 7 days
    # gc = {
    #   automatic = true;
    #   dates = "daily";
    #   options = "--delete-older-than 30d";
    # };
  };

  # Garbage collection
  services.nix-sweep = {
    enable = true;
    interval = "daily";
    removeOlder = "30d";
    keepMin = 20;
    gc = true;
    gcInterval = "daily";
  };
}
