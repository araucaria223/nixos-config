pkgs: {
  # example = pkgs.callPackage ./example { };

  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [grim slurp swappy];
    text = ''pgrep slurp || grim -g "$(slurp)" - | swappy -f -'';
  };

  connecto = pkgs.writeShellApplication {
    name = "connecto";
    runtimeInputs = with pkgs; [wpa_supplicant gnused];
    text = ''
      network = $(wpa_cli add_network | sed -n 2p)
      wpa_cli set_network $network ssid "$1"
      wpa_cli set_network $network psk "$2"
      wpa_cli select_network $network
    '';
  };
}
