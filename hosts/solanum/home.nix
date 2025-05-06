{ config, pkgs, inputs, ... } : {
  imports = [
    ../../modules/homeManager/default.nix
    ../../modules/nixos/systemcolor/colors.nix
    ../../modules/nixos/systemcolor/custom-mirage.nix
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

  #TODO remove
  services.stalonetray = {
    enable = true;
    config = {
      # window-type = "toolbar";
    };
  };

  #TODO remove unwanted entries; add entries for other things I might want
  xdg.desktopEntries = {
    nvim = {
      name = "NeoVim";
      exec = "nvim %f";
      type = "Application";
      terminal = true;
    };
  };

  #TODO cursor theme; test themes everywhere
  qt = {
    enable = true;
    platformTheme.name = "gtk"; #is this complete?
  };
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
  };
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    SOPS_AGE_KEY_FILE="${config.home.homeDirectory}/keys/age.txt";
    OPENER = "handlr open";
  };

  home.packages = [
    (pkgs.writeShellScriptBin "screenshot" ''
      #!/bin/zsh
      set -eu
      mode="''${1:-full}"
      filename="''${XDG_PICTURES_DIR:-$HOME/Pictures}/$(date +'%Y-%m-%d-%H%M%S').png"
      case "$mode" in
        full)
          grim "$filename" && wl-copy < "$filename"
          ;;
        monitor)
          mon=$(hyprctl monitors | awk '/Monitor /{mon=$2} /focused: yes/{print mon}')
          grim -o "$mon" "$filename" && wl-copy < "$filename"
          ;;
        window)
          geom=$(hyprctl activewindow | awk '
            /at:/   { split($2,a,","); x=a[1]; y=a[2] }
            /size:/ { split($2,s,","); w=s[1]; h=s[2] }
            END     { print x "," y " " w "x" h }
          ')
          grim -g "$geom" "$filename" && wl-copy < "$filename"
          ;;
        *)
          echo "Usage: screenshot [full|monitor|window]" >&2
          exit 1
          ;;
      esac
    '')
  ];

# Don't touch
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
