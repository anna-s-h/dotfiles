{ config, pkgs, ... } : {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ ];
    systemd.variables = ["--all"];

    settings = {
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$moda" = "SUPER";
      "$modb" = "SUPER_ALT";

      "$runner" = "rofi -show drun -show-icons";
      "$search" = "astal menu";
      "$calculator" = "[float] qalculate-qt || hyprctl dispatch focuswindow title:Qalculate"; #TODO doesn't work to focus window
      "$clipboard" = "astal toggle clipboard";
      "$fileManager" = "kitty -o confirm_os_window_close=0 yazi"; #TODO inelegant
      "$menu" = "astal menu main";
      #tasks
      "$tasks" = "[float] kitty -o confirm_os_window_close=0 btop";
      "$notes" = "obsidian";
      "$notifications" = "astal toggle notifications";
      "$clock" = "astal toggle clock";
      "$calendar" = "[float] kitty -o confirm_os_window_close=0 cal";
      #TODO this is unreliable because activewindow could include pid in title
      "$forcekill" = "hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill";
      "$controllerbinds" = ""; #TODO ???
      "$terminal" = "kitty";

      bind = [
        #Main binds
        "$moda, space, exec, $runner"
        "$modb, space, exec, $search"
        "$moda, B, exec, "
        "$modb, B, exec, "
        "$modb, C, exec, $calculator"
        "$modb, C, exec, $clipboard"
        "$moda, D, exec, "
        "$modb, D, exec, "
        "$moda, E, exec, $fileManager"
        "$modb, E, exec, "
        "$moda, F, fullscreen, 1"
        "$modb, F, fullscreen, 0"
        "$moda, G, togglefloating"
        "$modb, G, pin"
        "$moda, I, exec, "
        "$modb, I, exec, "
        "$moda, M, exec, $menu"
        "$modb, M, exec, $tasks"
        "$moda, N, exec, $notes"
        "$modb, N, exec, $notifications"
        "$moda, O, exec, "
        "$modb, O, exec, "
        "$moda, P, togglespecialworkspace, passwords"
        "$modb, P, exec, "
        "$moda, R, exec, "
        "$modb, R, exec, "
        "$moda, S, togglespecialworkspace, magic"
        "$modb, S, movetoworkspace, special:magic"
        "$moda, T, exec, $clock"
        "$modb, T, exec, $calendar"
        "$moda, U, exec, "
        "$modb, U, exec, "
        "$moda, V, exec, "
        "$modb, V, exec, "
        "$moda, W, killactive"
        "$modb, W, exec, $forcekill" 
        "$moda, Y, exec, $controllerbinds"
        "$modb, Y, exec, "
        "$moda, comma, exec, "
        "$modb, comma, exec, "
        "$moda, period, exec, "
        "$modb, period, exec, "
        "$moda, slash, exec, "#help
        "$modb, slash, exec, "#help
        "$moda, semicolon, togglespecialworkspace, term"
        "$modb, semicolon, exec, $terminal"
        "$moda, 1, workspace, 1"
        "$modb, 1, movetoworkspace, 1"
        "$moda, 2, workspace, 2"
        "$modb, 2, movetoworkspace, 2"
        "$moda, 3, workspace, 3"
        "$modb, 3, movetoworkspace, 3"
        "$moda, 4, workspace, 4"
        "$modb, 4, movetoworkspace, 4"
        "$moda, 5, workspace, 5"
        "$modb, 5, movetoworkspace, 5"
        "$moda, 6, workspace, 6"
        "$modb, 6, movetoworkspace, 6"
        "$moda, 7, workspace, 7"
        "$modb, 7, movetoworkspace, 7"
        "$moda, 8, workspace, 8"
        "$modb, 8, movetoworkspace, 8"
        "$moda, 9, workspace, 9"
        "$modb, 9, movetoworkspace, 9"
        "$moda, 0, movetoworkspacesilent, special:hidden"
        "$modb, 0, togglespecialworkspace, hidden"
        "$modb, 0, movetoworkspace, +0"
        # TODO: fix these
        #"     , Print, exec, grim - $(hyprctl monitors | awk '/at:/ { split($2, pos, \",\") x = pos[1] y = pos[2] } /size:/ { split($2, size, \",\") w = size[1] h = size[2] } END { print w \",\" h \" \" x \"x\" y }') | wl-copy && wl-paste > ${config.xdg.userDirs.pictures}/$(date +'%Y-%m-%d-%H%M%S.png')"
        #"$moda, Print, exec, grim -o $(hyprctl monitors | awk '/Monitor /{mon=$2} /focused: yes/{print mon}') | wl-copy && wl-paste > ${config.xdg.userDirs.pictures}/$(date +'%Y-%m-%d-%H%M%S.png')"
        #"$modb, Print, exec, grim - | wl-copy && wl-paste > ${config.xdg.userDirs.pictures}/$(date +'%Y-%m-%d-%H%M%S.png')"
        "     , Print, exec, grim - | wl-copy && wl-paste > ${config.xdg.userDirs.pictures}/$(date +'%Y-%m-%d-%H%M%S.png')"
        #"     , Print, exec, ${config.home.file."screenshot.sh".source} window"
        #"$moda, Print, exec, ${config.home.file."screenshot.sh".source} monitor"
        #"$modb, Print, exec, ${config.home.file."screenshot.sh".source} full"

        #Move focus
        "$moda, h, movefocus, l"
        "$moda, l, movefocus, r"
        "$moda, k, movefocus, u"
        "$moda, j, movefocus, d"
        "$moda, left,  movefocus, l"
        "$moda, right, movefocus, r"
        "$moda, up,    movefocus, u"
        "$moda, down,  movefocus, d"

        #History focus
        #TODO

        #Move window with mainmod + shift + arrows
        #TODO

      ];

      bindm = [
        #Move/resize windows
        "$moda, mouse:272, movewindow"
        "$moda, mouse:273, resizewindow"
      ];

      bindel = [
        #Control audio volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      misc = {
        focus_on_activate="true";
        key_press_enables_dpms="true";
      };

      exec-once = [
        "bash ~/dotfiles/startup.sh" #TODO remove entirely
        "[workspace special:term silent] $terminal" #TODO make unkillable?
        "[workspace special:hidden silent] kdeconnect-app"
        "[workspace special:hidden silent] antimicrox"
        #"swww init && swww img ~/dotfiles/wallpapers/quantum-moon.png"
        "hypridle"
        "solanoid"
      ];

      #windowrule = [
      #  "opacity 0.99, obsidian" #doesn't help. obsidian transparency is just broken.
      #];

      #workspace = [
      #  "w[tv1], gapsout:0, gapsin:0"
      #  "f[1], gapsout:0, gapsin:0"
      #];

      windowrulev2 = [
        "noinitialfocus, workspace special:passwords, class:(keepass)"
        #"bordersize 0, floating:0, onworkspace:w[tv1]"
        #"rounding 0, floating:0, onworkspace:w[tv1]"
        #"bordersize 0, floating:0, onworkspace:f[1]"
        #"rounding 0, floating:0, onworkspace:f[1]"
      ];

      layerrule = [
        "blur,rofi"
      ];

      animations = {
          enabled = "yes";

          # https://wiki.hyprland.org/Configuring/Animations/

          bezier = [
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "linear,   0.0,  0.0, 1.0, 1.0 "
          ];

          animation = [
            "windows, 1, 7, overshot"
            "windowsOut, 1, 7, default, popin 80%"
            "layers, 1, 7, overshot, slide"
            "layersOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
           #"borderangle, 1, 8, default"
            "borderangle, 1, 100, linear, loop"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
      };

      input = {
        follow_mouse = "2"; #0 (do nothing) might be better than 2 (mouse focus independent, key focus on click)
        float_switch_override_focus = "0";
      };

      monitor=",preferred,auto,auto";

      #env = [
      #  "XCURSOR_SIZE,24"
      #  "QT_QPA_PLATFORMTHEME,qt5ct"
      #];

      dwindle = {
        smart_split = "true";
      };

      general = { #defaults
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = "4";
        gaps_out = "8";
        border_size = "2";
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        #"col.active_border" = "rgba(${config.colorScheme.colors.base0C}ee) rgba(${config.colorScheme.colors.base0D}ee) 45deg";
        #"col.inactive_border" = "rgba(${config.colorScheme.colors.base03}aa)";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = "false";
      };

      decoration = { # defaults
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = "4";

        blur = {
          enabled = "true";
          size = "3";
          passes = "1";
          special = true; #might be doubling up?
        };

        shadow = {
          enabled = "true";
          range = "12";
          render_power = "2";
          ignore_window = "true";
          color = "0xee001a1a";
          color_inactive = "0x00000000";
        };
      };
    };
  };
}
