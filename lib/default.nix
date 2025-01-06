lib:
with builtins; rec {
  systems = [
    "x86_64-linux"
  ];

  paths = import ./paths.nix {inherit lib;};
  forAllSystems = lib.genAttrs systems;

  allNixFiles = y:
    (lib.filesystem.listFilesRecursive y)
    |> filter (x:
      baseNameOf x
      != "default.nix"
      && lib.hasSuffix ".nix" (toString x)
      && !lib.hasSuffix ".old.nix" (toString x));

  mapDefault = bool: features:
    features
    |> map (option: {
      name = option;
      value = {enable = lib.mkDefault bool;};
    })
    |> listToAttrs;
}
