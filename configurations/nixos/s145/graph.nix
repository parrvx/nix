{config, ...}: {
  sops.secrets.grafana_secret_key = {
    owner = "grafana";
  };

  services = {
    prometheus = {
      enable = true;
      port = 9090;
      scrapeConfigs = [
        {
          job_name = "node_exporter";
          static_configs = [
            {
              targets = ["127.0.0.1:9100"];
            }
          ];
        }
      ];
      exporters.node = {
        enable = true;
        enabledCollectors = ["systemd" "diskstats" "meminfo" "cpu"];
        port = 9100;
      };
    };

    grafana = {
      enable = true;

      settings = {
        server = {
          http_port = 3000;
          http_addr = "127.0.0.1";
        };
        security = {
          secret_key = "$__file{${config.sops.secrets.grafana_secret_key.path}}";
        };
      };
    };
  };
}
