{
  config,
  lib,
  ...
}: let
  # List of (normal) networks
  # Must have an ssid and (raw) psk
  # defined in $FLAKE/secrets/wireless.yaml
  networks = [
    "home"
    "hotspot"
  ];

  forAllNetworks = f: lib.mkMerge (builtins.map f networks);

  # Template for a wpa_supplicant configuration entry
  createWPAConfig = network: ''
    network={
      ssid="${config.sops.placeholder."wireless/${network}/ssid"}"
      psk=${config.sops.placeholder."wireless/${network}/pskRaw"}
    }
  '';
in {
  options.wpa_supplicant.enable = lib.my.mkDefaultTrueEnableOption ''
    wifi management with wpa_supplicant
  '';

  config = lib.mkIf config.wpa_supplicant.enable {
    networking.wireless = {
      enable = true;
      # Allow use of wpa_cli and similar
      userControlled.enable = true;
      # Load /etc/wpa_supplicant.conf
      allowAuxiliaryImperativeNetworks = true;
    };

    sops = {
      # Provision secrets for all networks
      secrets = let
	# Helper function to set the sops file of wireless secrets
	f = n: v: v // {sopsFile = lib.my.paths.secrets + /wireless.yaml;};
      in lib.mkMerge [
	(forAllNetworks (network: (lib.mapAttrs f {
	  "wireless/${network}/ssid" = {};
	  "wireless/${network}/pskRaw" = {};
	})))

	# Including eduroam
	(lib.mapAttrs f {
          "wireless/eduroam/identity" = {};
          "wireless/eduroam/password" = {};
          "wireless/eduroam/altsubject" = {};
          "wireless/eduroam/ca_cert" = {};
	})
      ];

      # Specify content of configuration file
      templates."wpa_supplicant.conf".content =
	(networks
	|> builtins.map(network: createWPAConfig network)
	|> lib.concatStringsSep "\n")
	# Extra configuration for eduroam
	+ "\n"
	+ ''
          network={
            ssid="eduroam"
            key_mgmt=WPA-EAP
            pairwise=CCMP
            group=CCMP TKIP
            eap=PEAP
            ca_cert="${config.sops.secrets."wireless/eduroam/ca_cert".path}"
            identity="${config.sops.placeholder."wireless/eduroam/identity"}"
            altsubject_match="${config.sops.placeholder."wireless/eduroam/altsubject"}"
            phase2="auth=MSCHAPV2"
            password="${config.sops.placeholder."wireless/eduroam/password"}"
          }
	'';
    };

    # Symlink /etc/wpa_supplicant.conf to generated configuration file
    environment.etc."wpa_supplicant.conf".source = config.sops.templates."wpa_supplicant.conf".path;
  };
}
