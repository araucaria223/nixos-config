{pkgs, inputs}: {
  # example = pkgs.callPackage ./example { };
  neovimConfigured = (inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [./nvf.nix];
  }).neovim;
}
