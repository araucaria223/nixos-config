{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  hasIPv6Internet = false;
  StateDirectory = "dnscrypt-proxy";

  blocklist_base = builtins.readFile inputs.oisd;
  # Add extra URLs to block
  extraBlocklist = '''';
  blocklist_txt = pkgs.writeText "blocklist.txt" ''
    ${extraBlocklist}
    ${blocklist_base}
  '';
in {
  options.encryptedDNS.enable = lib.mkEnableOption "encrypted dns proxy";

  config = lib.mkIf config.encryptedDNS.enable {
    # See https://wiki.nixos.org/wiki/Encrypted_DNS
    services.dnscrypt-proxy2 = {
      enable = true;
      # See https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
      settings = {
        blocked_names.blocked_names_file = blocklist_txt;

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"; # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
          cache_file = "/var/lib/${StateDirectory}/public-resolvers.md";
        };

        # Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
        ipv6_servers = hasIPv6Internet;
        block_ipv6 = ! (hasIPv6Internet);

        require_dnssec = true;
        require_nolog = false;
        require_nofilter = true;

        # If you want, choose a specific set of servers that come from your sources.
        # Here it's from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        # If you don't specify any, dnscrypt-proxy will automatically rank servers
        # that match your criteria and choose the best one.
        # server_names = [ ... ];
      };
    };

    systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = StateDirectory;
  };
}
