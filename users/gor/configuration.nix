{ config, pkgs, inputs, lib, ... } : {

  options = {
    user.gor.enable = lib.mkEnableOption "adds the gor user and desktop environment with all associated programs";
  };

  config = lib.mkIf config.user.gor.enable {
    users.users.gor = {
      isNormalUser = true;
      description = "gor";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "uinput"
      ];
      shell = pkgs.zsh;
    };
    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        "gor" = import ./home.nix;
      };
      backupFileExtension = "hm-backup";
      useGlobalPkgs = true;
    };

    programs = {
      hyprland = { #TODO can the module handle this?
        enable = true;
        package = inputs.hyprland.packages."${pkgs.system}".hyprland;
        xwayland.enable = true;
      };
      zsh.enable = true; #TODO modularize
      steam = { #TODO can this be moved?
        extraPackages = [ pkgs.hidapi ];
        extest.enable = true;
        enable = true;
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
