{ config, ... }:
{
  wayland.windowManager.river = {
    enable = true;
    extraSessionVariables = {
      "KIND_EXPERIMENTAL_PROVIDER" = "podman";
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
      "MOZ_ENABLE_WAYLAND" = "1";
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
    };
    extraConfig = ''
      mod="Mod4"

      riverctl spawn "swaybg -i ${config.home.homeDirectory}/nix/assets/wallpaper.jpg -m fill"
      riverctl spawn "bash ${config.home.homeDirectory}/nix/assets/scripts/terminal.sh"

      riverctl input pointer-1267-228-Elan_Touchpad tap enabled

      riverctl attach-mode bottom

      riverctl focus-follows-cursor disabled
      riverctl hide-cursor when-typing enabled
      riverctl hide-cursor timeout 5000

      # riverctl keyboard-layout -variant intl -options caps:escape us
      # riverctl keyboard-layout -options caps:escape br
      riverctl keyboard-layout br
      riverctl set-repeat 50 300

      # ===============================================
      # 2. Key Bindings (Keymaps)
      # ===============================================
      riverctl map normal $mod X       spawn fuzzel
      riverctl map normal $mod W       spawn qutebrowser
      riverctl map normal $mod+Shift P spawn "$HOME/.config/scripts/k3y-pass.sh"
      riverctl map normal $mod+Shift S spawn 'grim -g "$(slurp)" - | wl-copy'
      riverctl map normal $mod+Shift R spawn '~/.config/river/init'
      riverctl map normal $mod+Alt = spawn 'pulsemixer --change-volume +5'
      riverctl map normal $mod+Alt - spawn 'pulsemixer --change-volume -5'
      riverctl map normal $mod+Alt 0 spawn 'pulsemixer --toggle-mute'
      riverctl map normal Super+Shift Return spawn footclient
      riverctl map normal Super C close
      riverctl map normal Super J focus-view next
      riverctl map normal Super K focus-view previous
      riverctl map normal Super+Shift J swap next
      riverctl map normal Super+Shift K swap previous
      riverctl map normal Super Period focus-output next
      riverctl map normal Super Comma focus-output previous
      riverctl map normal Super+Shift Period send-to-output next
      riverctl map normal Super+Shift Comma send-to-output previous
      riverctl map normal Super Return zoom
      riverctl map normal Super H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Super L send-layout-cmd rivertile "main-ratio +0.05"
      riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1"
      riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"
      riverctl map normal Super+Alt H move left 100
      riverctl map normal Super+Alt J move down 100
      riverctl map normal Super+Alt K move up 100
      riverctl map normal Super+Alt L move right 100
      riverctl map normal Super+Alt+Control H snap left
      riverctl map normal Super+Alt+Control J snap down
      riverctl map normal Super+Alt+Control K snap up
      riverctl map normal Super+Alt+Control L snap right
      riverctl map normal Super+Alt+Shift H resize horizontal -100
      riverctl map normal Super+Alt+Shift J resize vertical 100
      riverctl map normal Super+Alt+Shift K resize vertical -100
      riverctl map normal Super+Alt+Shift L resize horizontal 100
      riverctl map-pointer normal Super BTN_LEFT move-view
      riverctl map-pointer normal Super BTN_RIGHT resize-view
      riverctl map-pointer normal Super BTN_MIDDLE toggle-float

      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done

      all_tags=$(((1 << 32) - 1))
      riverctl map normal Super 0 set-focused-tags $all_tags
      riverctl map normal Super+Shift 0 set-view-tags $all_tags
      riverctl map normal Super Space toggle-float
      riverctl map normal Super F toggle-fullscreen
      riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
      riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"
      riverctl declare-mode passthrough
      riverctl map normal Super F11 enter-mode passthrough
      riverctl map passthrough Super F11 enter-mode normal

      for mode in normal locked
      do
          # Eject the optical drive (well if you still have one that is)
          riverctl map $mode None XF86Eject spawn 'eject -T'

          # # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          # riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
          # riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
          # riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

          # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
          riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
          riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

          # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
          riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5%'
          riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
      done

      # Set background and border color
      riverctl background-color 0x000000
      riverctl border-color-focused 0x18f005
      riverctl border-color-unfocused 0x000000

      # Make all views with an app-id that starts with "float" and title "foo" start floating.
      riverctl rule-add -app-id 'float*' -title 'foo' float

      # Make all views with app-id "bar" and any title use client-side decorations
      riverctl rule-add -app-id "bar" csd
      riverctl rule-add -app-id "org.pwmt.zathura" csd
      riverctl rule-add -app-id "zathura" csd

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      rivertile -view-padding 0 -outer-padding 0 &
    '';
  };
  # ref: https://codeberg.org/river/wiki#user-content-how-do-i-disable-gtk-decorations-e-g-title-bar
  xdg.configFile."gtk-3.0/gtk.css".text = ''
    /* No (default) title bar on wayland */
    headerbar.default-decoration {
      margin-bottom: 50px;
      margin-top: -100px;
    }
    /* rm -rf window shadows */
    window.csd,
    window.csd decoration {
      box-shadow: none;
    }
  '';
}
