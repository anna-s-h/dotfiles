{ config, pkgs, inputs, lib, ... } : {

  imports = [
    ../../modules/nixos/keyboard.nix
  ]; 

  #This file defines nixOS options. For home-manager options, see home.nix

  options = {
    user.solanum.enable = lib.mkEnableOption "adds the solanum user and desktop environment with all associated programs";
  };

  config = lib.mkIf config.user.solanum.enable {
    users.users.solanum = {
      isNormalUser = true;
      description = "solanum";
      extraGroups = [
        "wireshark"
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

    modules.keymap.enable = true; #TODO can I move this to user?

    programs = {
      wireshark.enable = true;
      hyprland = { #TODO can the module handle this?
        enable = true;
        package = inputs.hyprland.packages."${pkgs.system}".hyprland;
        xwayland.enable = true;
      };
      zsh.enable = true; #TODO modularize
      #kdeconnect.enable = true; #TODO modularize; no longer works?
      steam = { #TODO can this be moved?
        extest.enable = true;
        enable = true;
        #gamescopeSession.enable = true;
      };
      git = {
        enable = true;
        config = {
          #TODO username and email?
          core.sshCommand = "ssh -i ~/keys/git-ssh"; #TODO use pass
          init.defaultBranch = "main";
        };
      };
    };

    #IPFS node; TODO Would be nice to move somewhere else, or make it not run all the time
    services.kubo = {
      #enable = true;
      defaultMode = "offline";
      startWhenNeeded = true;
    };

    virtualisation.waydroid.enable = true;

    # Why?
    services.udev.packages = with pkgs; [
      qmk
      qmk-udev-rules
      qmk_hid
      via
      vial
      antimicrox
      #plasma5Packages.kdeconnect-kde
    ];

    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        font-awesome
        source-han-sans
        open-sans
        source-han-serif
        nerd-fonts.meslo-lg
      ];
      fontconfig.defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "mesloLGS-Nerd-Font-Mono" ];
        #TODO add japanese fallbacks
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
        #xdg-desktop-portal-hyprland #included?
        xdg-desktop-portal-gtk
        #xdg-desktop-portal-termfilechooser #seems to break discord?
      ];
    };
  };
}
