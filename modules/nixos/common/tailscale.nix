{ pkgs, ... }:
{
  # Enable the Tailscale daemon service
  services.tailscale.enable = true;

  # Open Tailscale interface and standard UDP port in the firewall
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ]; # Default Tailscale listening port
  };
}
