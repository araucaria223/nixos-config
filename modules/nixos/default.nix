{
  lib,
  inputs,
  outputs,
  settings,
  ...
}: {
  imports = lib.my.validImports ./.;

  # Static options
  networking.hostName = "${settings.hostname}";
  i18n.defaultLocale = "en_GB.UTF-8";
  services.openssh.enable = true;

  # Firmware updates
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;

  # Dynamic options
  security.pam.services.hyprlock.fprintAuth = lib.mkDefault true;

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
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
# Features enabled by default
// lib.my.mapDefault true [
  # Secrets management
  "sops-nix"
  # Persistence management
  "impermanence"
  "homeManager"
  # Bootloader
  "systemd-boot"
  # Kernel patches
  "kernel-patches"
  # Set root password
  "root"
  # Set up user account
  "mainUser"
  "sudo"
  # Shell
  "zsh"
  # Audio
  "pipewire"
  "git"
  "battery"
  # Fingerprint scanner
  "fprintd"
  "btrfs-scrub"
  # Geolocation
  "geoclue"
  # Wifi
  "wpa_supplicant"
  # Global theming
  "stylix-theme"
  # Wayland compositor
  "hyprland"
]
# Features disabled by default
// lib.my.mapDefault false [
  # Secure boot
  "lanzaboote"
]
