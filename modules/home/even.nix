{
  pkgs,
  config,
  ...
}: {
  # Declarar as secrets no SOPS
  sops.secrets.even_terminal_token = {};
  sops.secrets.anthropic_api_key = {};

  systemd.user.services.even-terminal = {
    Unit = {
      Description = "Even Realities G2 Glasses Terminal Server";
      After = ["network.target" "sops-nix.service"];
    };
    Service = {
      Environment = [
        "PATH=${pkgs.lib.makeBinPath [pkgs.nodejs pkgs.bash pkgs.coreutils]}:/run/current-system/sw/bin"
        "ANTHROPIC_MODEL=claude-3-5-haiku-20241022"
      ];
      ExecStart = "${pkgs.bash}/bin/bash -c 'export ANTHROPIC_API_KEY=$(cat ${config.sops.secrets.anthropic_api_key.path}) && ${pkgs.nodejs}/bin/npx --yes @evenrealities/even-terminal --provider claude --token $(cat ${config.sops.secrets.even_terminal_token.path})'";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
