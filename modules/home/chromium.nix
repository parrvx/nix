{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override {enableWideVine = true;};
    extensions = [];
    commandLineArgs = [
      "--process-per-site"
      "--disable-background-networking"
      "--disable-default-apps"
      "--no-default-browser-check"
    ];
  };
}
