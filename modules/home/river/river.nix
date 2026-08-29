{
  config,
  pkgs,
  ...
}:
# Custom Passage menu script utilizing native clipboard flag (-c)
let
  passageMenu = pkgs.writeShellScriptBin "passage-menu" ''
    export PASSAGE_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
    export PASSAGE_DIR="$HOME/.passage"

    # Export essential dependencies to script PATH
    export PATH="${pkgs.lib.makeBinPath [pkgs.passage pkgs.fuzzel pkgs.wl-clipboard pkgs.libnotify pkgs.findutils pkgs.gnused]}:$PATH"
    SECRET=$(find "$PASSAGE_DIR" -type f -name "*.age" | sed "s|^$PASSAGE_DIR/||; s|\.age$||" | fuzzel --dmenu -p "  Passage: ")
    if [ -n "$SECRET" ]; then
      passage -c "$SECRET"
      notify-send "Passage" "Password for '$SECRET' copied to clipboard!"
    fi
  '';
in {
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
      # =========================================================================
      # 1. BACKGROUND SERVICES
      # =========================================================================
      riverctl spawn "swaybg -i ${config.home.homeDirectory}/nix/assets/wallpaper.jpg -m fill"

      # =========================================================================
      # 2. TAG BINDING RULES
      # =========================================================================
      riverctl rule-add -app-id "firefox" tags 2

      # =========================================================================
      # 3. AUTOSTART SEQUENCING
      # =========================================================================
      riverctl spawn 'bash -c "
        foot --server &
        sleep 0.5
        if wlr-randr | grep -q \"HDMI-A-1\"; then
          riverctl focus-output eDP-1
          riverctl set-focused-tags 1
          footclient --app-id btm-foot -e btm &
          sleep 0.8
          riverctl focus-output HDMI-A-1
          riverctl set-focused-tags 1
          footclient tmux new-session -A -s main &
          sleep 0.8
          riverctl set-focused-tags 2
          chromium &
          sleep 1.2
          riverctl focus-output HDMI-A-1
          riverctl set-focused-tags 2
        else
          riverctl focus-output eDP-1
          riverctl set-focused-tags 1
          footclient tmux new-session -A -s main &
          sleep 0.5
          riverctl set-focused-tags 2
          chromium &
          sleep 0.8
          riverctl set-focused-tags 4
          footclient --app-id btm-foot -e btm &
          sleep 0.5
          riverctl set-focused-tags 2
        fi
      "'

      # =========================================================================
      # 4. INPUT DEVICES & BEHAVIOR
      # =========================================================================
      riverctl input pointer-1267-228-Elan_Touchpad tap enabled
      riverctl attach-mode bottom
      riverctl focus-follows-cursor disabled
      riverctl hide-cursor when-typing enabled
      riverctl hide-cursor timeout 5000
      riverctl keyboard-layout br
      riverctl set-repeat 50 300

      # =========================================================================
      # 5. KEYBINDINGS
      # =========================================================================
      riverctl map normal $mod X spawn fuzzel
      riverctl map normal $mod W spawn firefox
      riverctl map normal $mod+Shift S spawn 'grim -g "$(slurp)" - | wl-copy'
      riverctl map normal $mod+Shift R spawn '~/.config/river/init'
      riverctl map normal $mod+Alt = spawn 'pulsemixer --change-volume +5'
      riverctl map normal $mod+Alt - spawn 'pulsemixer --change-volume -5'
      riverctl map normal $mod+Alt 0 spawn 'pulsemixer --toggle-mute'
      riverctl map normal Super+Shift Return spawn 'footclient tmux new-session -A -s main'

      # Passage secret generator mapping
      riverctl map normal $mod+Shift P spawn '${passageMenu}/bin/passage-menu'

      riverctl map normal Super C close

      # View focus and window movement
      riverctl map normal Super J focus-view next
      riverctl map normal Super K focus-view previous
      riverctl map normal Super+Shift J swap next
      riverctl map normal Super+Shift K swap previous

      # Monitor focus and view movement
      riverctl map normal Super Period focus-output next
      riverctl map normal Super Comma focus-output previous
      riverctl map normal Super+Shift Period send-to-output next
      riverctl map normal Super+Shift Comma send-to-output previous

      # Layout and zoom control
      riverctl map normal Super Return zoom
      riverctl map normal Super H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Super L send-layout-cmd rivertile "main-ratio +0.05"
      riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1"
      riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"

      # Floating window movement and snap
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

      # Mouse bindings
      riverctl map-pointer normal Super BTN_LEFT move-view
      riverctl map-pointer normal Super BTN_RIGHT resize-view
      riverctl map-pointer normal Super BTN_MIDDLE toggle-float

      # Dynamic Tag Mapping (1 to 9)
      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))
          riverctl map normal Super $i set-focused-tags $tags
          riverctl map normal Super+Shift $i set-view-tags $tags
          riverctl map normal Super+Control $i toggle-focused-tags $tags
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done
      all_tags=$(((1 << 32) - 1))
      riverctl map normal Super 0 set-focused-tags $all_tags
      riverctl map normal Super+Shift 0 set-view-tags $all_tags

      # Window layout modes
      riverctl map normal Super Space toggle-float
      riverctl map normal Super F toggle-fullscreen
      riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
      riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

      # Passthrough Mode
      riverctl declare-mode passthrough
      riverctl map normal Super F11 enter-mode passthrough
      riverctl map passthrough Super F11 enter-mode normal

      # Media and Brightness controls
      for mode in normal locked
      do
          riverctl map $mode None XF86Eject spawn 'eject -T'
          riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
          riverctl map $mode None XF86AudioNext  spawn 'playerctl next'
          riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5%'
          riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
      done

      # =========================================================================
      # 6. MATRIX COLOR THEME & NATIVE WINDOW RULES
      # =========================================================================
      riverctl background-color 0x000000
      riverctl border-color-focused 0x18f005
      riverctl border-color-unfocused 0x000000
      riverctl rule-add -app-id 'float*' -title 'foo' float
      riverctl rule-add -app-id "bar" csd
      riverctl rule-add -app-id "org.pwmt.zathura" csd
      riverctl rule-add -app-id "zathura" csd

      # Rivertile layout generator setup
      riverctl default-layout rivertile
      rivertile -view-padding 0 -outer-padding 0 &
    '';
  };

  # Disable redundant GTK window decorations under Wayland
  xdg.configFile."gtk-3.0/gtk.css".text = ''
    headerbar.default-decoration {
      margin-bottom: 50px;
      margin-top: -100px;
    }
    window.csd,
    window.csd decoration {
      box-shadow: none;
    }
  '';
}
