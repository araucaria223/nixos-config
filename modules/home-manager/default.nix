{
  lib,
  inputs,
  outputs,
  settings,
  ...
}: {
  imports =
    lib.my.validImports ./.
    ++ [inputs.impermanence.nixosModules.home-manager.impermanence];

  nixpkgs = {
    overlays = with outputs.overlays; [
      additions
      modifications
      unstable-packages
    ];

    config.allowUnfree = true;
  };

  # Define username and home directory
  home = {
    username = "${settings.username}";
    homeDirectory = "/home/${settings.username}";
  };

  # Enable home-manager
  programs.home-manager.enable = true;
  # Manage xdg base directories etc.
  xdg.enable = true;
}
