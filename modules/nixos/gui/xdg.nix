{pkgs, ...}: {
  # Configuração enxuta dos XDG Portals para o River (Wayland)
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    # Define explicitamente a ordem de preferência dos portais
    config = {
      common = {
        default = ["wlr" "gtk"];
      };
    };

    # Adiciona apenas o backend GTK como fallback
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
