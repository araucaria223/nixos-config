{inputs, ...}: {
  # Additional packages defined in $FLAKE/pkgs
  additions = final: _prev: {
    my = import ../pkgs final.pkgs;
  };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # Unstable nixpkgs is accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
