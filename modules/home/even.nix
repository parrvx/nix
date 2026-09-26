{
  pkgs,
  config,
  ...
}: {
  sops.secrets.even_terminal_token = {};

  systemd.user.services.even-terminal = {
    Unit = {
      Description = "Even Realities G2 Glasses Terminal Server (Local Ollama)";
      After = ["network.target" "ollama.service"];
    };
    Service = {
      Environment = [
        "PATH=${pkgs.lib.makeBinPath [pkgs.nodejs pkgs.bash pkgs.coreutils]}:/run/current-system/sw/bin"
        "OPENAI_API_BASE=http://127.0.0.1:11434/v1" # Aponta para a API do Ollama no Lenovo
        "OPENAI_MODEL=qwen2.5-coder:3b" # Modelo leve para respostas rápidas
      ];
      ExecStart = "${pkgs.nodejs}/bin/npx --yes @evenrealities/even-terminal --provider openai-compatible --token $(cat ${config.sops.secrets.even_terminal_token.path})";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
