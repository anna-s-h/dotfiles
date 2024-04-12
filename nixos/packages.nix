{ config, pkgs, inputs, ... } : {

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  #system basics
    kitty
    git-crypt
    sops
    grim
    vlc
    keepassxc #needs config
    ark #replace with something integrated with lf
    okular #needs config (should be last resort)
  #utilities
    kate #needs removed; currently useful for theme testing
    obsidian
    kfind
    #qbittorrent
    antimicrox
    filelight
    libsForQt5.kdeconnect-kde
    #libsForQt5.plasma-browser-integration #not working
    #pavucontrol
    digikam
    samba #replace with something faster
    qalculate-qt
    btop #maybe a little too much
    kfind
    discord
  #stuff to convert archived content
    #cherrytree
    #polyglot
  #games
    steam
    dolphin-emu
    #yuzu #must package myself
    #citra-nightly #must package myself
    #cemu #is broken right now
    desmume
    lutris #needs config
    prismlauncher #move instances somewhere sensible
    waydroid
    retroarch
    libretro.tic80
  #media
    #tachidesk
    #tagainijisho
  #project editors
    libreoffice
    gimp#-with-plugins #also, can krita replace this?
    aseprite #needs config (link palettes, import history)
    krita
    inkscape-with-extensions
    blender #config?
    obs-studio
    shotcut
    godot_4
    ldtk
    birdfont
  #hyprland things
    wl-clipboard # replace by clipboard manager of some kind?
    hyprlock #eww might replace this?
    eww
    hypridle #needs config(hybrid suspend)
    dunst #eww can replace this (eventually)
    swww #or wpaperd?
    rofi-wayland
    #some pop-from-top general system search
    #something to make unicode/emoji/altpage symbols
  ];

  services.udev.packages = with pkgs; [
    antimicrox
    kdeconnect
  ];

  programs.zsh.enable = true;
  programs.partition-manager.enable = true; #replace with something better-integrated with lf?
  programs.kdeconnect.enable = true; #barely works

  programs.git = {
    enable = true;
    config = {
      user.name = "anna-s-h";
      core.sshCommand = "ssh -i ~/keys/git-ssh";
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      open-sans
      source-han-sans-japanese
      source-han-serif-japanese
      meslo-lgs-nf
      nerdfonts
    ];
    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
    };
  };

  #hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    #nvidiaPatches = true;
    xwayland.enable = true;
  };

  #potential bugs' fixes
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # something to do with electron?
    WLR_NO_HARDWARE_CURSORS = "1";
    SOPS_AGE_KEY_FILE="${config.home-manager.users."solanum".home.homeDirectory}/keys/age.txt";
    OPENER = "handlr open";
  };

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.extraPortals = with pkgs; [
    #xdg-desktop-portal-hyprland
#termfilechooser (prob package myself)
  ];

}
