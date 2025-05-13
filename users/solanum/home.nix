{ config, pkgs, inputs, ... } : {
  imports = [
    ../../modules/homeManager/default.nix
    ../../modules/nixos/systemcolor/custom-mirage.nix
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
    #OPENER = "handlr open";
  };

  home.packages = with pkgs; [
  #desktop shell
    inputs.astal.packages.${system}.default
    inputs.solanoid.packages.${system}.default
    wl-clipboard
    grim
    hypridle #TODO module should install it; needs config(hybrid suspend)
    keepassxc #TODO config
    antimicrox #TODO replace
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default # TODO replace
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
  # Tools; TODO project editors should be moved to devenvs
    vlc
    ripgrep
    cachix
    devenv
    material-maker 
    libreoffice
    gimp#-with-plugins #also, can krita replace this?
    aseprite #needs config (link palettes, import history)
    krita
    inkscape-with-extensions
    blender #config?
    blockbench
    obs-studio
    # shotcut
    godot_4
    ldtk
    birdfont
    cargo
    #kicad
    vscodium
    jetbrains.idea-community
    #(symlinkJoin {
    #  name = "idea-community";
    #  paths = [ jetbrains.idea-community ];
    #  buildInputs = [ makeWrapper ];
    #  postBuild = ''
    #    wrapProgram $out/bin/idea-community \
    #    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libpulseaudio libGL glfw openal stdenv.cc.cc.lib]}"
    #  '';
    #})
  #games
    protonup-qt
    lutris #needs config
    r2modman
    dolphin-emu
    #yuzu #must package myself
    #citra-nightly #must package myself
    cemu #is broken right now
    # desmume #why do all the emulators break all the time 
    prismlauncher #move instances somewhere sensible
    glfw-wayland-minecraft
    waydroid
    retroarch
    libretro.tic80
  #desktop apps
    obsidian
    qbittorrent
    kdePackages.filelight
    digikam
    qalculate-qt
    btop #TODO configure; maybe a little too much
    vesktop
  #Trying out
    spotdl
  ];

# Don't touch
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
