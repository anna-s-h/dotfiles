{ config, pkgs, inputs, ... } : {

  nixpkgs.config.allowUnfree = true;

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = true;
    };

    zsh.enable = true;
    kdeconnect.enable = true; #barely works
    steam.enable = true;

    git = {
      enable = true;
      config = {
        user.name = "anna-s-h";
        core.sshCommand = "ssh -i ~/keys/git-ssh";
      };
    };

    nh = {
      enable = true;
      #clean.enable = true;
      #clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/solanum/dotfiles/nixos";
    };
  };

  environment.systemPackages = with pkgs; [
  #system basics
    git-crypt
    sops
    grim
    vlc
    keepassxc #needs config
    kdePackages.ark #replace with something integrated with lf
    kdePackages.okular #needs config (should be last resort)
    inputs.astal.packages.${system}.default
    inputs.solanoid.packages.${system}.default
  #utilities
    obsidian
    kanata
    #qbittorrent
    antimicrox
    kdePackages.filelight
    #plasma5Packages.kdeconnect-kde
    #libsForQt5.plasma-browser-integration #not working
    #pavucontrol
    digikam
    samba #replace with something faster
    qalculate-qt
    btop #maybe a little too much
    kdePackages.kfind
    vesktop
    kdePackages.xwaylandvideobridge #needed for discord jank
    ripgrep
    ganttproject-bin
    wireguard-tools
  #stuff to convert archived content
    #cherrytree
    #polyglot
  #games
    protonup-qt
    lutris #needs config
    r2modman
    dolphin-emu
    #yuzu #must package myself
    #citra-nightly #must package myself
    cemu #is broken right now
    # desmume #why do all the emulators break all the time 
    prismlauncher #move instances somewhere sensible
    glfw-wayland-minecraft
    waydroid
    retroarch
    libretro.tic80
  #media
    #tachidesk
    #tagainijisho
  #project editors
    cachix
    devenv
    material-maker 
    libreoffice
    gimp#-with-plugins #also, can krita replace this?
    aseprite #needs config (link palettes, import history)
    krita
    inkscape-with-extensions
    blender #config?
    blockbench
    obs-studio
    # shotcut
    godot_4
    ldtk
    birdfont
    cargo
    #kicad
    vscodium
    jetbrains.idea-community
    #(symlinkJoin {
    #  name = "idea-community";
    #  paths = [ jetbrains.idea-community ];
    #  buildInputs = [ makeWrapper ];
    #  postBuild = ''
    #    wrapProgram $out/bin/idea-community \
    #    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libpulseaudio libGL glfw openal stdenv.cc.cc.lib]}"
    #  '';
    #})
  #hyprland things
    wl-clipboard
    hypridle #needs config(hybrid suspend)
    #swww #or wpaperd?
    #inputs.astal
  ];

  # Why?
  services.udev.packages = with pkgs; [
    antimicrox
    plasma5Packages.kdeconnect-kde
  ];

  # IPFS node. Would be nice to move somewhere else
  services.kubo = {
    enable = true;
  };

  #TODO modularize; make antimicrox replacement; use xmodmap to change character outputs?
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

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      open-sans
      source-han-sans-japanese
      source-han-serif-japanese
      nerd-fonts.meslo-lg
    ];
    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "mesloLGS-Nerd-Font-Mono" ];
      #add japanese fallbacks
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # something to do with electron on wayland?
    WLR_NO_HARDWARE_CURSORS = "1"; # hyprland doesn't support nvidia hw cursor
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      #xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      #termfilechooser (prob package myself)
    ];
  };

}
