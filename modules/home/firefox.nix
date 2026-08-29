{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        # --- 1. DARK MODE ENFORCEMENT ---
        "layout.css.prefers-color-scheme.content-override" = 0;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;

        # --- 2. RAM & CPU OPTIMIZATIONS ---
        "dom.ipc.processCount" = 2;
        "browser.tabs.unloadOnLowMemory" = true;
        "gfx.webrender.all" = true;
        "media.hardware-video-decoding.enabled" = true;
        "browser.sessionstore.interval" = 60000;

        # --- 3. UI CUSTOMIZATIONS & TELEMETRY DISABLEMENT ---
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
      };

      # Minimal userChrome.css styling
      userChrome = ''
        /* 1. Hide default tab bar */
        #TabsToolbar {
          visibility: collapse !important;
        }
        /* 2. Top bar styling */
        :root {
          --toolbar-bgcolor: #1c1b22 !important;
          --lwt-accent-color: #1c1b22 !important;
          --urlbar-min-height: 22px !important;
        }
        /* 3. Compact navigation/URL bar height */
        #nav-bar {
          margin: 0 !important;
          padding: 1px 2px !important;
          max-height: 28px !important;
          min-height: 28px !important;
        }
        #urlbar-container {
          --urlbar-container-height: 22px !important;
          padding-top: 0px !important;
          padding-bottom: 0px !important;
        }
        #urlbar {
          min-height: 22px !important;
          max-height: 22px !important;
          top: 0 !important;
          font-size: 11px !important;
        }
        #urlbar-background {
          border-radius: 4px !important;
        }
        /* 4. Adjust internal icons and buttons for compact UI */
        #nav-bar .toolbarbutton-1 {
          padding: 1px !important;
        }
        #urlbar-input-container {
          padding-block: 0px !important;
          height: 22px !important;
        }
        .urlbar-icon {
          width: 14px !important;
          height: 14px !important;
        }
      '';
    };
  };
}
