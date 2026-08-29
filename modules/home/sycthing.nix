{ config, ... }:
{
  services.syncthing = {
    enable = true;
    # Web GUI is restricted to local access at http://127.0.0.1:8384
    guiAddress = "127.0.0.1:8384";
  };
}
