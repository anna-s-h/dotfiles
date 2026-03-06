{ lib, config, pkgs, ... } : {
  options = {
    modules.keymap.enable = lib.mkEnableOption "adds keyboard remappings designed for solanum";
  };

  config = lib.mkIf config.modules.keymap.enable {
    services.hardware.openrgb.enable = true;

    #environment.etc."xkb/symbols/alternate_punct".source = pkgs.writeText "alternate_punct" ''
    #xkb_symbols "basic" {
    #  include "us"

    #  key <AB08> { [ comma, semicolon ] };
    #  key <AB09> { [ period, colon ] };
    #  key <AB10> { [ question, exclam ] };
    #  key <AC10> { [ underscore, minus ] };
    #};
    #'';

    services.kanata = {
      enable = true;
      keyboards = {
        fortysix = {
          devices = ["/dev/input/by-id/usb-foostan_Corne_v4_vial:f64c2b3c-event-kbd"];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
          (defsrc
            grv  q    w    e    r    t    \        del    y    u    i    o    p    bspc
            esc  a    s    d    f    g    lctl     prnt   h    j    k    l    ;    '
            tab  z    x    c    v    b                    n    m    ,    .    /    ret
                                lsft spc  lalt     lmet   rsft rctl
          )

          (defalias
            ;; tap: backtick (grave), hold: toggle layer-switching layer while held
            grl (tap-hold 200 200 grv (layer-toggle modeswitch))
            cmk (layer-switch colemakdh)
            ;;qwr (layer-switch qwerty)
            gam (layer-switch games)

            ;;sym (layer-toggle symbols)
            nav (layer-toggle nav)

            ;; modkey stickiness
            sft (one-shot 500 lsft)
            ctl (one-shot 500 lctl)
            met (one-shot 500 lmet)
            alt (one-shot 500 lalt)
          )

          (deflayer colemakdh
            @grl q    w    f    p    b    XX        del  j    l    u    y    '    bspc
            esc  a    r    s    t    g    @alt      prnt m    n    e    i    o    ;   
            tab  z    x    c    d    v                        k    h    ,    .    /    ret
                                ralt spc  @nav      @met @sft @ctl
          )

          (deflayer games
            @grl q    w    f    p    b    XX        del  j    l    u    y    '    bspc
            esc  a    r    s    t    g    XX        prnt m    n    e    i    o    ;   
            tab  z    x    c    d    v                        k    h    ,    .    /    ret
                                ralt spc  sft       @met XX   ctl
          )

          ;;(deflayer symbols 
          ;;  @grl XX   XX   XX   XX   XX   XX        del  XX   7    8    9    -    bspc
          ;;  esc  XX   XX   XX   XX   XX   XX        prnt XX   4    5    6    +    XX
          ;;  tab  XX   XX   XX   XX   XX                  XX   1    2    3    .    ret
          ;;                      @alt @sft ralt      @met 0    XX
          ;;)

          (deflayer nav 
            @grl XX   XX   up   XX   XX   XX        del  XX   XX   XX   XX   XX   bspc
            esc  XX   left rght down XX   XX        prnt XX   XX   XX   XX   XX   XX
            tab  XX   XX   XX   XX   XX                  XX   XX   XX   XX   XX   ret
                                @alt @sft ralt      @met spc  @ctl
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

