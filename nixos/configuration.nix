{ config, pkgs, inputs, ... } : {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #system basics
    kitty
    git
    #neovim-qt #needs config (as flake)
    keepassxc #needs config
    vlc
    ffmpegthumbs #idk if I need this
    libsForQt5.kdegraphics-thumbnailers #idk if I need this
    ark #replace?
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
    #synology-drive #needs config
    digikam
    samba
    qalculate-qt
    btop
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
  #games
    steam
    kfind
    #yuzu
    dolphin-emu
    #citra-nightly
    #cemu #is broken right now
    desmume
    lutris #needs config
    prismlauncher #move instances somewhere sensible
    waydroid
    retroarch#Full
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
    grim
    waybar #eww can replace this
    #hyprlock #eww can replace this
    eww
    #hypridle
    dunst #eww can replace this (eventually)
    swww #or wpaperd?
    rofi-wayland
    #some pop-from-top general system search and calculator
    #something to make unicode/emoji/altpage symbols
  #themes
    libsForQt5.breeze-qt5
    libsForQt5.breeze-gtk
    libsForQt5.breeze-grub
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.solanum = {
    isNormalUser = true;
    description = "solanum";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      discord
      sqlitebrowser
      zsh-powerlevel10k #needs config
    #stuff to convert archived content
      #cherrytree
      #polyglot
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;
  security.polkit.enable = true; #doesn't work?????


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

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  #xdg.portal.extraPortals = with pkgs; [
    #xdg-desktop-portal-hyprland
  #  xdg-desktop-portal-kde #probably comes with kde
  #];

  # Enable the X11 windowing system.
  # Do I really need this?
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

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
  };

  services.udev.packages = with pkgs; [
    antimicrox
  ];

  #services.actkbd = {
  #  enable = true;
  #  bindings = [
  #    #{ keys = [ 224 ]; events = [ "key" ]; command = "/run/wrappers/bin/light -A 10"; }
  #    # meta+space for search, meta+grave for console (goto not open), ctrl+alt+grave for force close, ctrl+shift+grave for task manager
  #  ];
  #};

  fileSystems."/mnt/NAS/webscrape" = {
    device = "//192.168.8.183/Webscrape";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=/home/solanum/secrets/smb.txt,uid=1000,gid=100"];
  };

  fileSystems."/mnt/NAS/media" = {
    device = "//192.168.8.183/Media";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=/home/solanum/secrets/smb.txt,uid=1000,gid=100"];
  };

  #fileSystems."/mnt/NAS/backups" = { #excluded because it is used rarely enough that a mount seems overkill
  #  device = "//192.168.8.183/Backups";
  #  fsType = "cifs";
  #  options = let
  #    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #  in ["${automount_opts},credentials=./secrets/smb.txt,uid=1000,gid=100"];
  #};

  #fileSystems."/mnt/NAS/sync" = { # excluded because hopefully synology sync works
  #  device = "//192.168.8.183/Sync";
  #  fsType = "cifs";
  #  options = let
  #    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #  in ["${automount_opts},credentials=./secrets/smb.txt,uid=1000,gid=100"];
  #};

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.
  #services.xserver.displayManager.sddm.autoNumlock = true;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "solanum" = import ./home.nix;
    };
  };


  #system.autoUpgrade = {
  #  enable = true;
  #  flake = inputs.self.outPath;
  #  flags = [
  #    "--update-input"
  #    "nixpkgs"
  #    "-L"
  #  ];
  #  dates = "9:00"
  #}

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    #useOSProber = true;
  };

  #boot.supportedFilesystems = [ "ntfs" ];

  hardware.bluetooth.enable = true;

  networking.hostName = "Solanum"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Don't touch
  system.stateVersion = "23.11"; # Did you read the comment?

}

