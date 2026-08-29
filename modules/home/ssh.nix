{ config
, ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "/home/${config.me.username}/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "my-server" = {
        hostname = "192.168.1.100";
        user = "root";
        port = 2222;
        identityFile = "/home/${config.me.username}/.ssh/id_rsa";
      };
    };
  };
}
