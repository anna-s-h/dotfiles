{ config, pkgs, inputs, ... } : {
    imports = [
        ./home-managed/firefox.nix
            ./home-managed/hyprland.nix
            ./home-managed/terminal.nix
            inputs.nixvim.homeManagerModules.nixvim
    ];

    home.username = "solanum";
    home.homeDirectory = "/home/solanum";
    xdg.userDirs = {
        enable = true;
        desktop = "${config.home.homeDirectory}/desktop";
        documents = "${config.home.homeDirectory}/documents";
        download = "${config.home.homeDirectory}/downloads";
        pictures = "${config.home.homeDirectory}/pictures";
        videos = "${config.home.homeDirectory}/videos";
        music = "${config.home.homeDirectory}/music";
    };
    
    programs.eww.configDir = ./home-managed/eww;

    programs.nixvim = import ./home-managed/nvim/nixvim.nix;

### None of this section works, for some reason

#qt = {
#  enable = true;
#  platformTheme = "kde";
#  style.name = "breeze";
#};

#qt = {
#  enable = true;
#  platformTheme = "gnome";
#  style = {
#    name = "Breeze-Dark";
#    package = pkgs.libsForQt5.breeze-qt5;
#  };
#};

#home.pointerCursor = {
#  gtk.enable = true;
#  package = pkgs.libsForQt5.breeze-gtk;
#  name = "Breeze-Dark";
#  size = 16;
#};

#home.sessionVariables = {
#  GTK_THEME = "Breeze";
#};

#gtk = {
#  enable = true;
#  theme = {
#    name = "Breeze-Dark";
#    package = pkgs.libsForQt5.breeze-gtk;
#  };
#};


    home.file = {
        ".config/hypr/hypridle.conf".source = ./home-managed/hypridle.conf;
    };

# Investigate uses for this
#home.sessionVariables = {
# EDITOR = "emacs";
#};

    home.packages = [
# # You can also create simple shell scripts directly inside your
# # configuration. For example, this adds a command 'my-hello' to your
# # environment:
# (pkgs.writeShellScriptBin "my-hello" ''
#   echo "Hello, ${config.home.username}!"
# '')
    ];

# Don't touch
    programs.home-manager.enable = true;
    home.stateVersion = "23.11";
                                }
