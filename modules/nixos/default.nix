{ pkgs, lib, ... }: {

  imports = [
    ./doas.nix
    ./main-user.nix
    ./firefox.nix
  ];

  doas.enable = lib.mkDefault true;
  main-user.enable = lib.mkDefault true;
}
