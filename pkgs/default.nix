pkgs: {
  # example = pkgs.callPackage ./example { };

  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [grim slurp swappy];
    text = ''pgrep slurp || grim -g "$(slurp)" - | swappy -f -'';
  };
}
