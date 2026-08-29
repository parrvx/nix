{pkgs, ...}: {
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
    keyboards = {
      matrix-input = {
        config = ''
          (defsrc
            caps q a s d f
            8 9 0 u i o p
            j k l ;
            n m , .
          )
          (defvar
            tap-timeout 150
            hold-timeout 200
          )
          ;; =========================================================================
          ;; 1. BASE LAYER
          ;; =========================================================================
          (deflayer base
            (tap-hold $tap-timeout $hold-timeout esc (layer-toggle mods)) q a s d f
            8 9 0 u i o p
            j k l ;
            n m , .
          )
          ;; =========================================================================
          ;; 2. MODIFIERS LAYER (Active only WHILE holding CapsLock)
          ;; =========================================================================
          (deflayer mods
            _
            (layer-switch numpad) ;; Caps + Q: Jumps to numpad layer and LOCKS there
            lmet lalt lctl lsft
            _ _ _ _ _ _ _
            _ _ _ _
            _ _ _ _
          )
          ;; =========================================================================
          ;; 3. NUMPAD LAYER (Extended and locked numeric matrix)
          ;; =========================================================================
          (deflayer numpad
            _
            (layer-switch base)   ;; Pressing Caps + Q here UNLOCKS and returns to base!
            _ _ _ _
            kp/ kp* kp- kp7 kp8 kp9 kp+
            kp4 kp5 kp6 kp.
            kp0 kp1 kp2 kp.
          )
        '';
      };
    };
  };
}
