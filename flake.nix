{
  description = "NixOS Config Flake";

  inputs = {
    # CURRENT STABLE VERSION - NIXOS 24.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ephemeral filesystem management
    impermanence.url = "github:nix-community/impermanence";

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware optimisations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Theming
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib =
      nixpkgs.lib.extend
      (final: prev:
        {my = import ./lib final;}
        // inputs.home-manager.lib);
  in {
    packages = lib.my.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};

    formatter = lib.my.forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosConfigurations = {
      lookfar = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs lib;
          settings = import ./hosts/lookfar/settings.nix;
        };

        modules = with inputs; [
          disko.nixosModules.default
          (import ./hosts/lookfar/disko.nix {device = "/dev/nvme0n1";})

          ./hosts/lookfar/configuration.nix
          ./modules/nixos

          home-manager.nixosModules.default
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
	  lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.framework-12th-gen-intel
	  stylix.nixosModules.stylix
        ];
      };
    };
  };
}
