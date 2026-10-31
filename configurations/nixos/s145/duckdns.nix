{
  pkgs,
  config,
  ...
}: {
  # SOPS secret declaration
  sops.secrets.duckdns_token = {};

  # systemd service for DuckDNS dynamic DNS updates
  systemd.services.duckdns = {
    description = "DuckDNS Dynamic IP Update";
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -s \"https://www.duckdns.org/update?domains=parrvx-qg&token=$(cat ${config.sops.secrets.duckdns_token.path})&ip=\"'";
    };
  };

  # Timer to trigger DuckDNS updates every 5 minutes
  systemd.timers.duckdns = {
    description = "Update DuckDNS every 5 minutes";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
    };
  };
}
