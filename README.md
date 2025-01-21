# NixOS System Configuration
This repo houses my NixOS configuration flake, which builds the NixOS system running on my laptop. It is designed to be modular so that it can build potential future NixOS systems as well.

WARNING - this will not work on an arbitrary system. Several parts of my configuration rely on secrets which can only be decrypted by my own ssh key.

## Main features
Besides the obvious (flakes, home-manager as a nixos module, etc.) there is also notably:

- [Impermanence](https://github.com/nix-community/impermanence) using tmpfs on root
- Declarative secrets with [sops-nix](https://github.com/Mic92/sops-nix)
- Secure boot with [Lanzaboote](https://github.com/nix-community/lanzaboote)
- Global colorscheming and typography with [Stylix](https://github.com/danth/stylix)
- A small collection of custom functions housed in an overlay under `lib.my`
- Both the latest stable version of nixpkgs (`pkgs`) and the unstable branch (`pkgs.unstable`) are available
