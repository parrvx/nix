{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=11";
        shell = "${pkgs.nushell}/bin/nu";
      };
      colors-dark = {
        background = "000000";
        foreground = "ffffff";
      };
    };
  };
}
