{
  config,
  lib,
  settings,
  ...
}: let
  username = config.users.users.${settings.username}.name;
in {
  options.syncthing.enable = lib.my.mkDefaultTrueEnableOption ''
    syncthing - self-hosted file sync
  '';

  config = lib.mkIf config.syncthing.enable {
    sops.secrets = {
      "syncthing/cert.pem" = {
	format = "binary";
	sopsFile = lib.my.paths.secrets + /syncthing/cert.pem;
      };

      "syncthing/key.pem" = {
	format = "binary";
	sopsFile = lib.my.paths.secrets + /syncthing/key.pem;
      };
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = settings.username;
      dataDir = "/persist/home/${settings.username}";
      configDir = "/persist/home/${settings.username}/.config/syncthing";

      settings = {
	cert = config.sops.secrets."syncthing/cert.pem".path;
	key = config.sops.secrets."syncthing/key.pem".path;

	options.urAccepted = -1;

        gui = {
          user = username;
          # Awaiting merge of https://github.com/NixOS/nixpkgs/pull/290485
          password = "password";
        };

        devices.phone = {
          id = "7JTFZJC-NJGSLWY-RIW7P2I-GXU5BY3-MVEAIK3-U6NQVY2-LD5DMX3-WAB5SAF";
        };

        folders = {
          "Passwords" = {
            path = "/persist/home/${username}/.local/share/passwords";
            devices = ["phone"];
          };
        };
      };
    };

    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  };
}
