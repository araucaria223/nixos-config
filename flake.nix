{
  description = "NixOS Config Flake";

  inputs = {
    # CURRENT STABLE VERSION - NIXOS 24.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {self, nixpkgs, ...} @ inputs: {
    nixosConfigurations = {
      lookfar = nixpkgs.lib.nixosSystem {
	specialArgs = { inherit inputs; };

	modules = [];
      };
    };
  };
}
