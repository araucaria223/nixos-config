{
  config,
  lib,
  ...
}: {
  options.ssh.enable = lib.my.mkDefaultTrueEnableOption "SSH";

  config = lib.mkIf config.ssh.enable {
    networking.nftables.enable = true;

    services = {
      openssh = {
	enable = true;
      };
      # Ban hosts that cause multiple authentication errors
      fail2ban.enable = true;
      # Slow down malicious SSH connection attempts by delaying connections
      endlessh = {
	enable = true;
	port = 22;
	openFirewall = true;
      };
    };
  };
}
