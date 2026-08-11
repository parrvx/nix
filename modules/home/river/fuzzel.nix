{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        width = 30;

        font = "JetBrainsMono Nerd Font:size=20";

        terminal = "foot";
        layer = "overlay";

        horizontal-pad = 10;
        vertical-pad = 10;
        inner-pad = 10;
      };
      colors = {
        background = "000000ff";
        text = "ffffffff";
        selection = "39ff14ff";
        selection-text = "000000ff";
        border = "39ff14ff";
      };
      border = {
        width = 2;
        radius = 7;
      };
    };
  };
}
