{...}: {
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
    keyboards = {
      matrix-input = {
        config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          (defvar
            tap-timeout 150
            hold-timeout 200
          )

          ;; =========================================================================
          ;; 1. BASE LAYER (QWERTY)
          ;; =========================================================================
          (deflayer base
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            (tap-hold $tap-timeout $hold-timeout esc (layer-toggle mods)) a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          ;; =========================================================================
          ;; 2. matrix LAYER
          ;; =========================================================================
          (deflayer matrix
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            (tap-hold $tap-timeout $hold-timeout esc (layer-toggle mods)) a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          ;; =========================================================================
          ;; 3. MODS LAYER
          ;; =========================================================================
          (deflayer mods
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    7    8    9    +    [    ]    \
            (tap-hold $tap-timeout $hold-timeout esc (layer-toggle base)) a    s    d    f    g    h    4    5    6    -    S-8    ret
            lsft z    x    (layer-switch matrix)    v    b    0    1    2    3    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          ;; =========================================================================
          ;; 4. MODS LAYER (Estando no matrix -> Caps + C volta para QWERTY)
          ;; =========================================================================
          (deflayer mods-matrix
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    7    8    9    +    [    ]    \
            (tap-hold $tap-timeout $hold-timeout esc (layer-toggle base)) a    s    d    f    g    h    4    5    6    -    S-8    ret
            lsft z    x    (layer-switch matrix)    v    b    0    1    2    3    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )
        '';
      };
    };
  };
}
