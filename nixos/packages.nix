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
    libsForQt5.dolphin #replace
    ark #replace?
    #neovim-qt #needs config (as flake)
    ffmpegthumbs #idk if I need this
    libsForQt5.kdegraphics-thumbnailers #idk if I need this
    okular #needs config (should be last resort)
  #utilities
    libsForQt5.ksystemlog #skill issue
    kate #needs removed
    obsidian
    kfind
    partition-manager
    qbittorrent
    antimicrox #needs config
    filelight
    libsForQt5.kdeconnect-kde
    #libsForQt5.plasma-browser-integration #not working
    #pavucontrol
    digikam
    samba
    qalculate-qt
    btop
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    discord
  #stuff to convert archived content
    sqlitebrowser
    #cherrytree
    #polyglot
  #games
    steam
    kfind
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
    gimp#-with-plugins
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
    libsForQt5.polkit-kde-agent #doesn't work?????
    lxqt.lxqt-policykit #to mount things with dolphin
    wl-clipboard # replace by clipboard manager of some kind?
    hyprlock #eww might replace this?
    eww
    hypridle #needs config(hybrid suspend)
    dunst #eww can replace this (eventually)
    swww #or wpaperd?
    rofi-wayland
    #some pop-from-top general system search
    #something to make unicode/emoji/altpage symbols
  #themes
    libsForQt5.breeze-qt5
    libsForQt5.breeze-gtk
    libsForQt5.breeze-grub
  ];

  services.udev.packages = with pkgs; [
    antimicrox
  ];

  programs.zsh.enable = true;
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true; #barely works
  security.polkit.enable = true; #doesn't work?????

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
    QT_STYLE_OVERRIDE="breeze";
    SOPS_AGE_KEY_FILE="~/keys/age.txt";
  };
  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  #xdg.portal.extraPortals = with pkgs; [
    #xdg-desktop-portal-hyprland
  #  xdg-desktop-portal-kde #probably comes with kde
  #];

}
