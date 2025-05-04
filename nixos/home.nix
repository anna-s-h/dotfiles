{ config, pkgs, inputs, ... } : {
  imports = [
    ./home-managed/firefox/firefox.nix
    ./home-managed/hyprland.nix
    ./home-managed/terminal.nix
    ./home-managed/lf.nix
    ./home-managed/yazi.nix
    ./home-managed/rofi.nix
    inputs.nixvim.homeManagerModules.nixvim
    #inputs.ags.homeManagerModules.default 
    ./systemcolor/colors.nix
    ./systemcolor/custom-mirage.nix
  ];

  #programs.ags = {
  #  enable = true;
  #  configDir = ./home-managed/ags;

    # additional packages to add to gjs's runtime
    #extraPackages = with pkgs; [
    #  gtksourceview
    #  webkitgtk
    #  accountsservice
    #];
  #};

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
  services.stalonetray = {
    enable = true;
    config = {
      # window-type = "toolbar";
    };
  };

  xdg.desktopEntries = {
    nvim = {
      name = "NeoVim";
      exec = "nvim %f";
      type = "Application";
      terminal = true;
    };
  };

### None of this section works, for some reason

#qt = {
#  enable = true;
#  platformTheme = "kde";
#  style.name = "breeze";
#};

  qt = {
    enable = true;
    platformTheme.name = "gtk"; #is this complete?
#    style = {
#      name = "Breeze-Dark";
#      package = pkgs.libsForQt5.breeze-qt5;
#    };
  };

#  home.pointerCursor = {
#    gtk.enable = true;
#    package = pkgs.libsForQt5.breeze-gtk;
#    name = "Breeze-Dark";
#    size = 16;
#  };

#  home.sessionVariables = {
#    GTK_THEME = "Breeze";
#  };

  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-blue-standard+normal";
      package = pkgs.catppuccin-gtk.override {
        size = "standard";
        accents = ["blue"];
        variant = "mocha";
        tweaks = ["normal"];
      };
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

#  theme = {
#    name = "Breeze-Dark";
#    package = pkgs.libsForQt5.breeze-gtk;
#  };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  home.file = {
    ".config/hypr/hypridle.conf".source = ./home-managed/hypridle.conf;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    SOPS_AGE_KEY_FILE="${config.home.homeDirectory}/keys/age.txt";
    OPENER = "handlr open";
  };

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
