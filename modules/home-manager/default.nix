{
  config,
  lib,
  inputs,
  outputs,
  settings,
  ...
}: {
  imports =
    lib.my.validImports ./.
    ++ [inputs.impermanence.nixosModules.home-manager.impermanence];

  options = let
    inherit (lib.types) str;
  in {
    configDir = lib.mkOption {
      type = str;
      default = ".config";
    };

    cacheDir = lib.mkOption {
      type = str;
      default = ".cache";
    };

    dataDir = lib.mkOption {
      type = str;
      default = ".local/share";
    };

    stateDir = lib.mkOption {
      type = str;
      default = ".local/state";
    };
  };

  config = {
    nixpkgs = {
      overlays = with outputs.overlays; [
        additions
        modifications
        unstable-packages
      ];

      config.allowUnfree = true;
    };

    # Define username and home directory
    home = rec {
      username = settings.username;
      homeDirectory = "/home/${username}";
    };

    # Enable home-manager
    programs.home-manager.enable = true;
    # Manage xdg base directories etc.
    xdg = let
      home = config.home.homeDirectory;
    in {
      enable = true;
      configHome = home + "/${config.configDir}";
      dataHome = home + "/${config.dataDir}";
      cacheHome = home + "/${config.cacheDir}";
      stateHome = home + "/${config.stateDir}";
    };
  };
}
