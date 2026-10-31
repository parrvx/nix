{pkgs, ...}: {
  # Streamlined XDG Portals configuration for River (Wayland)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # Explicitly define portal preference order
    config = {
      common = {
        default = ["wlr" "gtk"];
      };
    };
    # Include GTK backend as a fallback
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
