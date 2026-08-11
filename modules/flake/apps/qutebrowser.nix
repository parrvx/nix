{ ... }:
{
  perSystem = { pkgs, lib, config, ... }:
  let
    configpy = pkgs.writeText "config.py" ''

config.load_autoconfig(False)
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set("content.headers.accept_language", "", "https://matchmaker.krunker.io/*")
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:145.0) Gecko/20100101 Firefox/145.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {qt_key}/{qt_version} {upstream_browser_key}/{upstream_browser_version_short} Safari/{webkit_version}', 'https://gitlab.gnome.org/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.clipboard', 'access-paste', 'https://gemini.google.com')
config.set('content.javascript.clipboard', 'access-paste', 'https://github.com')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
config.set('content.local_content_can_access_remote_urls', True, 'file:///home/parrvx/.local/share/qutebrowser/userscripts/*')
config.set('content.local_content_can_access_file_urls', False, 'file:///home/parrvx/.local/share/qutebrowser/userscripts/*')
c.tabs.show = 'never'
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}', 'duck': 'https://duckduckgo.com/?q={}', 'archive': 'https://archive.org/search?query={}', 'yt': 'https://www.youtube.com/results?search_query={}'}
c.url.start_pages = 'https://gemini.google.com/app'
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = 'smart'
config.bind(';H', 'hint links spawn --detach mpv {hint-url}')
config.bind(';L', 'hint links spawn --detach mpv --ytdl-format="bestvideo[height<=480]+bestaudio/best[height<=480]" {hint-url}')
    '';
  in {
    packages.myqutebrowser = pkgs.symlinkJoin {
      name = "myqutebrowser";
      paths = [ pkgs.qutebrowser ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/qutebrowser \
          --prefix PATH : ${lib.makeBinPath [ config.packages.myhelix ]} \
          --add-flags "--config-py ${configpy}"
      '';

      meta = { mainProgram = "qutebrowser"; };
    };
  };
}
