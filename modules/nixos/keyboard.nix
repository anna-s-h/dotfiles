{ lib, config, ... } : {
  options = {
    modules.keymap.enable = lib.mkEnableOption "adds keyboard remappings designed for solanum";
  };

  config = lib.mkIf config.modules.keymap.enable {
    #TODO make antimicrox replacement; use xmodmap to change character outputs?
    services.kanata = {
      enable = true;
      keyboards = {
        main = {
          devices = [];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          (defalias
            ;; tap: backtick (grave), hold: toggle layer-switching layer while held
            grl (tap-hold 200 200 grv (layer-toggle layers))

            ;; layer-switch changes the base layer.
            qwr (layer-switch qwerty)
            cmk (layer-switch colemakdh)
            gam (layer-switch games)

            ;; tap for escape, hold for control
            cap (tap-hold-press 200 200 esc lctl)

            ;; modkey stickiness
            sft (one-shot 500 lsft)
            ctl (one-shot 500 lctl)
            met (one-shot 500 lmet)
            alt (one-shot 500 lalt)
          )

          (deflayer qwerty
            @grl 1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @cap a    s    d    f    g    h    j    k    l    ;    '    ret
            @sft z    x    c    v    b    n    m    ,    .    /    rsft
            @ctl @met @alt           spc            ralt rmet rctl
          )

          (deflayer games
            @grl 1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @cap a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          (deflayer colemakdh
            @grl 1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    f    p    b    j    l    u    y    ;    [    ]    \
            @cap a    r    s    t    g    m    n    e    i    o    '    ret
            @sft x    c    d    v    z    k    h    ,    .    /    rsft
            @ctl @met @alt           spc            ralt rmet rctl
          )

          (deflayer layers
            _    @qwr @cmk @gam    _    _    _    _    _    _    _    _    _    _
            _    _    _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _              _              _    _    _
          )
          '';
        };
      };
    };
  };
}
