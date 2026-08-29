{ pkgs, ... }:
{

  programs.river-classic = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    slurp
    grim
    swaybg
    wl-clipboard
    wlr-which-key
    wlr-randr
    pulsemixer
    brightnessctl
    libnotify
  ];

  fonts.packages = with pkgs;[
    nerd-fonts.jetbrains-mono
    libertine
  ];

  services = {
    displayManager.ly = {
      enable = true;
      settings.animation = "matrix";
    };
  };

}
