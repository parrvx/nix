{
  pkgs,
  config,
  ...
}: {
  # 1. Declaração dos Segredos geridos pelo SOPS
  sops.secrets.wireguard_private_key = {};
  sops.secrets.duckdns_token = {};

  # 2. Resiliência e Ferramentas Remotas
  programs.mosh.enable = true; # Abre automaticamente as portas UDP 60000-61000

  environment.systemPackages = with pkgs; [
    waypipe
    wireguard-tools
  ];

  # 3. Interface WireGuard Nativa (wg0)
  networking.wireguard.interfaces.wg0 = {
    ips = ["10.0.0.1/24"];
    listenPort = 51820;
    privateKeyFile = config.sops.secrets.wireguard_private_key.path;

    peers = [
      {
        # Motorola Edge 40 Neo
        publicKey = "E4XCiDMowhddg6Q0iwqtLGac2mpPMfUqh8rtIOvuLFs=";
        allowedIPs = ["10.0.0.2/32"];
      }
    ];
  };

  # Libera a porta do WireGuard no firewall do NixOS
  networking.firewall.allowedUDPPorts = [51820];

  # 4. Atualização Automática do DuckDNS
  systemd.services.duckdns = {
    description = "DuckDNS Dynamic IP Update";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -s \"https://www.duckdns.org/update?domains=parrvx-qg&token=$(cat ${config.sops.secrets.duckdns_token.path})&ip=\"'";
    };
  };

  systemd.timers.duckdns = {
    description = "Atualiza o DuckDNS a cada 5 minutos";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
    };
  };
}
