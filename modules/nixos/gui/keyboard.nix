{pkgs, ...}: {
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
    keyboards = {
      matrix-input = {
        config = ''
          (defsrc
            grv  1 2 3 4 5 6 7 8 9 0 - =
            tab  q w e r t y u i o p [ ] \
            caps a s d f g h j k l ; '
            lsft z x c v b n m , . / rsft
          )

          (defvar
            tap-timeout 150
            hold-timeout 200
          )

          ;; =========================================================================
          ;; 1. BASE LAYER (QWERTY)
          ;; =========================================================================
          (deflayer base
            grv  1 2 3 4 5 6 7 8 9 0 - =
            tab  q w e r t y u i o p [ ] \
            (tap-hold $tap-timeout $hold-timeout esc (layer-toggle mods)) a s d f g h j k l ; '
            lsft z x c v b n m , . / rsft
          )

          ;; =========================================================================
          ;; 2. CANARY LAYER
          ;; =========================================================================
          (deflayer canary
            grv  1 2 3 4 5 6 7 8 9 0 - =
            tab  w l y m k z f o u ' [ ] \
            (tap-hold $tap-timeout $hold-timeout esc (layer-toggle mods-canary)) c r s t g p n e i a ;
            lsft q j v d b x h / , . rsft
          )

          ;; =========================================================================
          ;; 3. MODS LAYER (Estando no QWERTY -> Caps + C ativa Canary)
          ;; =========================================================================
          (deflayer mods
            _    _ _ _ _ _ _ _ _ _ _ _ _
            _    (layer-switch numpad) _ _ _ _ _ _ _ _ _ _ _ _
            _    lmet lalt lctl lsft _ _ _ _ _ _ _
            _    _ _ (layer-switch canary) _ _ _ _ _ _ _ _
          )

          ;; =========================================================================
          ;; 4. MODS LAYER (Estando no Canary -> Caps + C volta para QWERTY)
          ;; =========================================================================
          (deflayer mods-canary
            _    _ _ _ _ _ _ _ _ _ _ _ _
            _    (layer-switch numpad) _ _ _ _ _ _ _ _ _ _ _ _
            _    lmet lalt lctl lsft _ _ _ _ _ _ _
            _    _ _ (layer-switch base) _ _ _ _ _ _ _ _
          )

          ;; =========================================================================
          ;; 5. NUMPAD LAYER
          ;; =========================================================================
          (deflayer numpad
            _    _ _ _ _ _ _ _ _ _ _ _ _
            _    (layer-switch base) _ _ _ _ kp/ kp* kp- kp7 kp8 kp9 kp+ _
            _    _ _ _ _ _ kp4 kp5 kp6 kp. _ _
            _    _ _ _ _ _ kp0 kp1 kp2 kp. _ _
          )
        '';
      };
    };
  };
}
