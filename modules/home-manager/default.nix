{ pkgs, lib, ... }: {
  
  imports = [
    ./hyprland.nix
    ./cursor.nix
    ./mako.nix
    ./alacritty.nix
    ./zsh.nix
    ./firefox.nix
  ];

  hyprland.enable = lib.mkDefault true;
  mako.enable = lib.mkDefault true;
  alacritty.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  cursor.enable = lib.mkDefault true;
  firefox.userConfig = lib.mkDefault true;
}
