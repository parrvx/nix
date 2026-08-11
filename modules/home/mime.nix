{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "qutebrowser.desktop" ];
      "x-scheme-handler/http" = [ "qutebrowser.desktop" ];
      "x-scheme-handler/https" = [ "qutebrowser.desktop" ];
      "x-scheme-handler/about" = [ "qutebrowser.desktop" ];
      "x-scheme-handler/unknown" = [ "qutebrowser.desktop" ];
      "application/xhtml+xml" = [ "qutebrowser.desktop" ];
    };
  };

  xdg.configFile."mimeapps.list".force = true;
}
