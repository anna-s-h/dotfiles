{ config, pkgs, inputs, ... } : {
  imports = [
    #../../modules/homeManager/default.nix
    ../../modules/homeManager/hyprland/hyprland.nix
    ../../modules/homeManager/firefox/firefox.nix
    ../../modules/homeManager/systemcolor/colors.nix
    ../../modules/homeManager/terminal/terminal.nix
    ../../modules/homeManager/nixvim/nixvim.nix
    ../../modules/homeManager/yazi.nix
    ../../modules/homeManager/rofi.nix
  ];

  modules.terminal.enable = true;
  colors = import ../../modules/homeManager/systemcolor/custom-mirage.nix {inherit config;};
  modules.hyprland = {
    enable = true;
    binds = [
          #Main binds
          "$moda, space, exec, $runner"
          "$moda, R, exit"
          "$moda, G, togglefloating"
          "$modb, H, pin"

          "$moda, N, exec, $notifications"
          "$moda, E, exec, $fileManager"
          "$moda, L, togglespecialworkspace, term"
          "$moda, semicolon, exec, $terminal"

          "$moda, W, killactive"
          "$moda, F, fullscreen, 1"

          "$moda, Y, exec, $controllerbinds"

          "$moda, Z, workspace, 1" 
          "$modb, Z, movetoworkspace, 1" 
          "$moda, X, workspace, 2" 
          "$modb, X, movetoworkspace, 2" 
          "$moda, C, workspace, 3"
          "$modb, C, movetoworkspace, 3"
          "$moda, V, workspace, 4"
          "$modb, V, movetoworkspace, 4"
          "$moda, B, workspace, 5"
          "$modb, B, movetoworkspace, 5"

          #Screenshots
          "     , Print, exec, screenshot window"
          "$moda, Print, exec, screenshot monitor"
          "$modb, Print, exec, screenshot full"

        ];
  };


  home.username = "gor";
  home.homeDirectory = "/home/gor";
  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
    music = "${config.home.homeDirectory}/music";
  };

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
    gtk4.theme = config.gtk.theme;
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
    #OPENER = "handlr open";
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$XDG_DATA_HOME/dotfiles/private/passwords";
      PASSWORD_STORE_CLIP_TIME = "60";
    };
  };

  programs.vesktop = {
    enable = true;
  };

  home.packages = with pkgs; [
  #desktop shell
    quickshell
    wl-clipboard
    grim
    playerctl
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default # TODO replace
    (pkgs.writeShellScriptBin "screenshot" ''
      #!/bin/zsh
      set -euo pipefail 
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
  # Tools 
    btop #TODO configure; maybe a little too much
    mpv #TODO test
    ripgrep
    libei # may fix steaminput?
    obs-studio
  #games
    protonup-qt # Does GOR need this?
    r2modman
    dolphin-emu
    #yuzu #must package myself
    #citra-nightly #must package myself
    cemu #is broken right now
    # desmume #why do all the emulators break all the time 
    prismlauncher #move instances somewhere sensible
    glfw3-minecraft
    satisfactorymodmanager
  #desktop apps
    vlc
    #qbittorrent
    kdePackages.filelight
  ];

# Don't touch
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
