{ lib, config, pkgs, ... } : {
  options = {
    modules.keymap.enable = lib.mkEnableOption "adds keyboard remappings designed for solanum";
  };

  config = lib.mkIf config.modules.keymap.enable {
    services.hardware.openrgb.enable = true;
    
    services.keyd = {
      enable = true;
      keyboards = {
        mouse = {
          ids = ["1532:00b2:19ad785e"];
          settings = {
            main = {
              mouse2 = "rightshift";
              mouse1 = "rightcontrol";
            };
          };
        };
      };
    };
    
    services.kanata = {
      enable = true;
      keyboards = {
        fortysix = {
          devices = ["/dev/input/by-id/usb-foostan_Corne_v4_vial:f64c2b3c-event-kbd"];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
          (defsrc
            grv  q    w    f    p    b    \        del    j    l    u    y    '    bspc
            esc  a    r    s    t    g    lctl     prnt   m    n    e    i    o    ;
            tab  z    x    c    d    v                    k    h    ,    .    /    ret
                                lalt spc  ralt     lmet   rsft rctl
          )

          (defalias
            ;; tap: backtick (grave), hold: toggle layer-switching layer while held
            grl (tap-hold 200 200 grv (layer-toggle modeswitch))
            cmk (layer-switch colemakdh)
            ;;qwr (layer-switch qwerty)
            gam (layer-switch games)

            nav (layer-toggle nav)

            ;; modkey stickiness
            sft (fork (one-shot 500 lsft) 0 (ralt))
            ctl (one-shot 500 lctl)
            met (one-shot 500 lmet)
            alt (one-shot 500 lalt)
            sym (one-shot 500 ralt)

            ;; experimental
            tab (tap-hold 200 200 tab alt)    
          )

          (deflayer colemakdh
            @grl q    w    f    p    b    \         del  j    l    u    y    '    bspc
            esc  a    r    s    t    g    @alt      prnt m    n    e    i    o    -   
            @tab z    x    c    d    v                   k    h    ,    .    /    ret
                                @nav spc  @sym      @met @sft @ctl
          )

          (deflayer games
            @grl q    w    f    p    b    XX        del  j    l    u    y    '    bspc
            esc  a    r    s    t    g    XX        prnt m    n    e    i    o    -   
            @tab z    x    c    d    v                   k    h    ,    .    /    ret
                                ctl  spc  lalt      @met @sft @sym
          )

          (deflayer nav 
            @grl f1   f2   f3   f4   f5   f6        ins  XX   XX   XX   XX   XX   bspc
            esc  f7   f8   f9   f10  f11  f12       XX   left down up   rght XX   XX
            tab  f13  f14  XX   XX   XX                  XX   XX   XX   XX   XX   ret
                                @alt @sft lalt      @met spc  @ctl
          )

          (deflayer modeswitch
            XX   @cmk @gam XX   XX   XX   XX        XX   XX   XX   XX   XX   XX   XX
            XX   XX   XX   XX   XX   XX   XX        XX   XX   XX   XX   XX   XX   XX
            XX   XX   XX   XX   XX   XX                  XX   XX   XX   XX   XX   XX
                                XX   XX   XX        XX   XX   XX
          )
          '';
        };
        sixty = {
          devices = ["/dev/input/by-id/usb-DELL_Dell_USB_Wired_Entry_Keyboard-event-kbd"];
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

