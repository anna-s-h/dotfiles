{ config, pkgs, inputs, ... } : {
  imports = [
    ../../modules/homeManager/default.nix
  ];

  modules.terminal.enable = true;
  colors = import ../../modules/homeManager/systemcolor/custom-mirage.nix {inherit config;};

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

  # TODO move these to a music module
  programs.beets = {
    enable = true;
    settings = {
      plugins = "fetchart chroma missing edit duplicates fromfilename ftintitle";
      directory = "~/music/maintained";
    };
    #mpdIntegration? rewrite?
  };
  services.mpd = {
    enable = true;
    musicDirectory = "~/music/maintained/";
    extraConfig = ''
      audio_output {
        type            "pipewire"
        name            "PipeWire Sound Server"
      }
    '';
  };
  services.mpd-mpris.enable = true;
  programs.rmpc = {
    enable = true;
    config = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
        address: "127.0.0.1:6600",
        password: None,
        theme: None,
        cache_dir: None,
        on_song_change: None,
        volume_step: 5,
        max_fps: 30,
        scrolloff: 0,
        wrap_navigation: false,
        enable_mouse: true,
        status_update_interval_ms: 1000,
        select_current_song_on_change: false,
        album_art: (
          method: Auto,
          max_size_px: (width: 1200, height: 1200),
          disabled_protocols: ["http://", "https://"],
          vertical_align: Center,
          horizontal_align: Center,
        ),
        keybinds: (
          global: {
            ":":       CommandMode,
            ",":       VolumeDown,
            "s":       Stop,
            ".":       VolumeUp,
            "<Tab>":   NextTab,
            "<S-Tab>": PreviousTab,
            "1":       SwitchToTab("Queue"),
            "2":       SwitchToTab("Directories"),
            "3":       SwitchToTab("Artists"),
            "4":       SwitchToTab("Album Artists"),
            "5":       SwitchToTab("Albums"),
            "6":       SwitchToTab("Playlists"),
            "7":       SwitchToTab("Search"),
            "q":       Quit,
            ">":       NextTrack,
            "p":       TogglePause,
            "<":       PreviousTrack,
            "f":       SeekForward,
            "z":       ToggleRepeat,
            "x":       ToggleRandom,
            "c":       ToggleConsume,
            "v":       ToggleSingle,
            "b":       SeekBack,
            "~":       ShowHelp,
            "I":       ShowCurrentSongInfo,
            "O":       ShowOutputs,
            "P":       ShowDecoders,
          },
          navigation: {
            "k":         Up,
            "j":         Down,
            "h":         Left,
            "l":         Right,
            "<Up>":      Up,
            "<Down>":    Down,
            "<Left>":    Left,
            "<Right>":   Right,
            "<C-k>":     PaneUp,
            "<C-j>":     PaneDown,
            "<C-h>":     PaneLeft,
            "<C-l>":     PaneRight,
            "<C-u>":     UpHalf,
            "N":         PreviousResult,
            "a":         Add,
            "A":         AddAll,
            "r":         Rename,
            "n":         NextResult,
            "g":         Top,
            "<Space>":   Select,
            "<C-Space>": InvertSelection,
            "G":         Bottom,
            "<CR>":      Confirm,
            "i":         FocusInput,
            "J":         MoveDown,
            "<C-d>":     DownHalf,
            "/":         EnterSearch,
            "<C-c>":     Close,
            "<Esc>":     Close,
            "K":         MoveUp,
            "D":         Delete,
          },
          queue: {
            "D":       DeleteAll,
            "<CR>":    Play,
            "<C-s>":   Save,
            "a":       AddToPlaylist,
            "d":       Delete,
            "i":       ShowInfo,
            "C":       JumpToCurrent,
          },
        ),
        search: (
          case_sensitive: false,
          mode: Contains,
          tags: [
            (value: "any",         label: "Any Tag"),
            (value: "artist",      label: "Artist"),
            (value: "album",       label: "Album"),
            (value: "albumartist", label: "Album Artist"),
            (value: "title",       label: "Title"),
            (value: "filename",    label: "Filename"),
            (value: "genre",       label: "Genre"),
          ],
        ),
        artists: (
          album_display_mode: SplitByDate,
          album_sort_by: Date,
        ),
        tabs: [
          (
            name: "Queue",
            pane: Split(
              direction: Horizontal,
              panes: [(size: "40%", pane: Pane(AlbumArt)), (size: "60%", pane: Pane(Queue))],
            ),
          ),
          (
            name: "Directories",
            pane: Pane(Directories),
          ),
          (
            name: "Artists",
            pane: Pane(Artists),
          ),
          (
            name: "Album Artists",
            pane: Pane(AlbumArtists),
          ),
          (
            name: "Albums",
            pane: Pane(Albums),
          ),
          (
            name: "Playlists",
            pane: Pane(Playlists),
          ),
          (
            name: "Search",
            pane: Pane(Search),
          ),
        ],
      )
    '';
  };

  home.packages = with pkgs; [
  #desktop shell
    #inputs.astal.packages.${system}.default
    #inputs.solanoid.packages.${system}.default
    #quickshell
    wl-clipboard
    grim
    keepassxc #TODO replace
    antimicrox #TODO replace
    playerctl
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
  # Tools 
    btop #TODO configure; maybe a little too much
    mpv #TODO test
    spotdl
    ripgrep
    cachix
    devenv
  # project editors; TODO many should be moved to devenvs
    material-maker 
    libreoffice
    gimp3#-with-plugins #also, can krita replace this?
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
    satisfactorymodmanager
  #desktop apps
    vlc
    obsidian
    qbittorrent
    kdePackages.filelight
    digikam
    qalculate-qt
  ];

# Don't touch
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
