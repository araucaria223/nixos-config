lib:
with builtins; rec {
  systems = [
    "x86_64-linux"
  ];

  paths = import ./paths.nix {inherit lib;};
  forAllSystems = lib.genAttrs systems;
  symlink = map (dir: {directory = dir; method = "symlink"; });

  validImports = dir:
    (readDir dir)
    |> lib.filterAttrs (n: v:
      n != "default.nix" &&
      (v == "directory" || (lib.hasSuffix ".nix" n && !lib.hasSuffix ".old.nix" n)))
    |> lib.mapAttrsToList (name: type: dir + "/${name}");

  mkDefaultTrueEnableOption = name: lib.mkEnableOption name // {default = true; example = false;};
}
