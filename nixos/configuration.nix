{ config, pkgs, inputs, ... } : {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  #system basics
    kitty
    git
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
    #hypridle #disabled for now for being buggy
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

  users.users.solanum = {
    isNormalUser = true;
    description = "solanum";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      discord
    #stuff to convert archived content
      sqlitebrowser
      #cherrytree
      #polyglot
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true; #barely works
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

  users.users.keepass-start = {
    home = "/var/lib/keepass-start";
    createHome = true;
    isSystemUser = true;
    group = "keepass-start";
  };
  users.groups.keepass-start = {};
  sops.secrets.keepass = {owner="keepass-start";};
  systemd.user.services.keepass-start = {
    description = "unlock keepass vault on startup";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = ''
      cat ${config.sops.secrets.keepass.path} | keepassxc --pw-stdin ~/SynologyDrive/Passwords.kdbx
    '';
    wantedBy = ["default.target"];
    serviceConfig = {
      User = "keepass-start";
      WorkingDirectory = "/var/lib/keepass-start";
    };
  };


  # sops secrets go into the nix store and can be rolled back, are encrypted with two keys, but can only be accessed by specific users.
  # files in ~/dotfiles/private/ are encrypted with only one of the two keys, and are not put into the nix store, but can be accessed by all userspace programs.
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/solanum/Keys/age.txt";
  #sops.secrets."path" = {owner="service";}; #to publish one to /run/secrets/path
  #${config.sops.secrets."path".path} #to get path to secret for use in a service (remember to set the owner)

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  #xdg.portal.extraPortals = with pkgs; [
    #xdg-desktop-portal-hyprland
  #  xdg-desktop-portal-kde #probably comes with kde
  #];

  # NixOS has some confusing, unnecessary coupling with xserver
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
    SOPS_AGE_KEY_FILE="~/Keys/age.txt";
  };

  services.udev.packages = with pkgs; [
    antimicrox
  ];

  sops.secrets.nas_credentials = {};
  fileSystems."/mnt/NAS/webscrape" = {
    device = "//192.168.8.183/Webscrape";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/NAS/media" = {
    device = "//192.168.8.183/Media";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true; # Required!
    open = false;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  home-manager = {
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

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    #useOSProber = true;
  };

  #boot.supportedFilesystems = [ "ntfs" ];

  hardware.bluetooth.enable = true;

  networking.hostName = "Solanum";

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
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

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
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

