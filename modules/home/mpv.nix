{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    config = {
      ytdl-raw-options = "extractor-args=\"youtube:player_client=android,web\"";
    };
  };
}
