{ config, pkgs, ... } : {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ ];
    systemd.variables = ["--all"];

    settings = {
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$moda" = "SUPER";
      "$modb" = "SUPER_ALT";

      "$terminal" = "kitty";
      "$fileManager" = "kitty lf"; #TODO inelegant
      "$menu" = "rofi -show drun -show-icons";
      "$calculator" = "[float] qalculate-qt || hyprctl dispatch focuswindow title:Qalculate"; #TODO doesn't work to focus window
      "$search" = "";

      #TODO consider groups

      bind = [
        #WS-IDs keys: 1 2 3 4 5 6 7 8 9 0 W S P J H
        #B-less keys: L E C M N V T ?
        #Unused keys: R Y U I O B < >
        #Banned keys: Q A Z X

        #Main binds
        "$moda, space, exec, $menu"
        "$moda, space, pass, rofi" #TODO should be more precise
        "$modb, space, exec, $search"
        #TODO antimicrox toggle
        "$moda, D, exec, "#TODO desktop
        "$modb, D, exec, "#TODO peek
        "$moda, F, fullscreen, 0"
        "$modb, F, fullscreen, 1"
        "$moda, G, togglefloating"
        "$modb, G, pin"
        "$modb, J, exec, $terminal"
        "$moda, K, killactive"
        "$modb, K, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill" #TODO this is unreliable because activewindow could include pid in title
        "$moda, L, exec, "#TODO help
        "$moda, E, exec, $fileManager"
        "$moda, C, exec, $calculator"
        "$moda, M, exit"#TODO replace with menu
        "$moda, N, exec, obsidian"
        "$moda, V, exec, "#TODO clipboard
        "$moda, T, exec, "#TODO time
        "$moda, semicolon, exec, "#TODO perfreport
        "$modb, semicolon, exec, "#TODO top
        "$moda, question,  exec, "#TODO notifications

        #Take screenshots
        "     , Print, exec, grim - | wl-copy && wl-paste > $(xdg-user-dir PICTURES)/$(date +'%Y-%m-%d-%H%M%S.png')" #TODO one-window
        "$moda, Print, exec, grim - | wl-copy && wl-paste > $(xdg-user-dir PICTURES)/$(date +'%Y-%m-%d-%H%M%S.png')" #TODO one-screen
        "$modb, Print, exec, grim - | wl-copy && wl-paste > $(xdg-user-dir PICTURES)/$(date +'%Y-%m-%d-%H%M%S.png')"

        #Move focus
        "$moda, left,  movefocus, l"
        "$moda, right, movefocus, r"
        "$moda, up,    movefocus, u"
        "$moda, down,  movefocus, d"

        #History focus
        #TODO

        #Move window with mainmod + shift + arrows
        #TODO

        #Switch workspaces
        "$moda, 1, workspace, 1"
        "$moda, 2, workspace, 2"
        "$moda, 3, workspace, 3"
        "$moda, 4, workspace, 4"
        "$moda, 5, workspace, 5"
        "$moda, 6, workspace, 6"
        "$moda, 7, workspace, 7"
        "$moda, 8, workspace, 8"
        "$moda, 9, workspace, 9"
        "$moda, 0, workspace, 10"
        "$moda, W, togglespecialworkspace, magic"
        "$moda, S, workspace, school"
        "$moda, P, togglespecialworkspace, passwords"
        "$moda, J, togglespecialworkspace, term"
        "$moda, H, movetoworkspacesilent, special:hidden"

        #Move active window to a workspace
        "$modb, 1, movetoworkspace, 1"
        "$modb, 2, movetoworkspace, 2"
        "$modb, 3, movetoworkspace, 3"
        "$modb, 4, movetoworkspace, 4"
        "$modb, 5, movetoworkspace, 5"
        "$modb, 6, movetoworkspace, 6"
        "$modb, 7, movetoworkspace, 7"
        "$modb, 8, movetoworkspace, 8"
        "$modb, 9, movetoworkspace, 9"
        "$modb, 0, movetoworkspace, 10"
        "$modb, W, movetoworkspace, special:magic"
        "$modb, S, movetoworkspace, school"
        "$modb, H, togglespecialworkspace, hidden"
        "$modb, H, movetoworkspace, +0"

        #Scroll through existing workspaces
        "$moda, mouse_down, workspace, e+1"
        "$moda, mouse_up,   workspace, e-1"
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
        "swww init && swww img ~/dotfiles/wallpapers/quantum-moon.png"
        "hypridle"
      ];

      #windowrule = [
      #  "opacity 0.99, obsidian" #doesn't help. obsidian transparency is just broken.
      #];

      windowrulev2 = [
        "noinitialfocus, workspace special:passwords, class:(keepass)"
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

          drop_shadow = "yes";
          shadow_range = "4";
          shadow_render_power = "3";
          "col.shadow" = "rgba(1a1a1aee)";
      };
    };
  };
}
