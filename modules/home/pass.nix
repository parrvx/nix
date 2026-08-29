{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    passage
    age
    wtype
    wl-clipboard
  ];

  programs.bash.sessionVariables = {
    PASSAGE_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    PASSAGE_DIR = "${config.home.homeDirectory}/.passage";
  };
}
