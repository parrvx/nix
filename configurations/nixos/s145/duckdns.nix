{
  pkgs,
  config,
  ...
}: {
  # Declaração do segredo no SOPS
  sops.secrets.duckdns_token = {};

  # Serviço systemd para atualizar o DuckDNS
  systemd.services.duckdns = {
    description = "DuckDNS Dynamic IP Update";
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -s \"https://www.duckdns.org/update?domains=parrvx-qg&token=$(cat ${config.sops.secrets.duckdns_token.path})&ip=\"'";
    };
  };

  # Timer para rodar o serviço a cada 5 minutos
  systemd.timers.duckdns = {
    description = "Atualiza o DuckDNS a cada 5 minutos";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
    };
  };
}
