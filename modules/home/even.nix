{ pkgs, config, ... }:
{
  sops.secrets.even_terminal_token = { };

  systemd.user.services.even-terminal = {
    Unit = {
      Description = "Even Realities G2 Glasses Terminal Server";
      After = [ "network.target" "sops-nix.service" ];
    };
    Service = {
      # Ensure npx locates system binaries, Node, Bash, and core utilities
      Environment = [
        "PATH=${pkgs.lib.makeBinPath [ pkgs.nodejs pkgs.bash pkgs.coreutils ]}:/run/current-system/sw/bin"
      ];
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.nodejs}/bin/npx --yes @evenrealities/even-terminal --provider claude --model claude-3-5-haiku --token $(cat ${config.sops.secrets.even_terminal_token.path})'";
      Restart = "always";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
