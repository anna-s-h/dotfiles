{ config, pkgs, inputs, ... } : {

  users.users.solanum = {
    isNormalUser = true;
    description = "solanum";
    extraGroups = [
      "networkmanager"
      "wheel"
      config.services.kubo.group
      "input"
      "uinput"
    ];
    shell = pkgs.zsh;
  };
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "solanum" = import ./home.nix;
    };
    backupFileExtension = "hm-backup";
    useGlobalPkgs = true;
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = true;
    };
    zsh.enable = true;
    kdeconnect.enable = true; #TODO modularize; barely works
    steam.enable = true; #TODO can this be moved?
    git = {
      enable = true;
      config = {
        #TODO username and email?
        core.sshCommand = "ssh -i ~/keys/git-ssh";
        init.defaultBranch = "main";
      };
    };
  };
  
  #IPFS node. Would be nice to move somewhere else, or make it not run all the time
  services.kubo = {
    enable = true;
  };

  # Why?
  services.udev.packages = with pkgs; [
    antimicrox
    plasma5Packages.kdeconnect-kde
  ];

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
