{pkgs, ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=11";
      };
      colors-dark = {
        background = "000000";
        foreground = "ffffff";
      };
    };
  };
}
