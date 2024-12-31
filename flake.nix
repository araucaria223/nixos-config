{
  description = "NixOS Config Flake";

  inputs = {
    # CURRENT STABLE VERSION - NIXOS 24.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib.extend (final: prev: {my = import ./lib final;});
  in {
    packages = lib.my.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      lookfar = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs lib;};

        modules = [./hosts/lookfar/configuration.nix];
      };
    };
  };
}
