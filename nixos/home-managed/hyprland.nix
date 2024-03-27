{config, pkgs, ...}:

{
  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [

    ];

    #unfortunately binds must be done like this to use submaps as of current version.
    extraConfig = ''

    #Main binds
      submap = reset
      bind = $mainMod, space, exec, $menu
      #desktop
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, J, togglespecialworkspace, term
      bind = $mainMod, K, killactive,
      #help
      #task manager
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, T, exec, $terminal
      #maximize
      #hide
      bind = $mainMod, Y, exec, [float] $calculator || hyprctl dispatch focuswindow title:Qalculate
      #search
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, M, exit, #replace with powermenu
      bind = $mainMod, N, exec, obsidian
      bind = $mainMod, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill
      #controller script toggle
      bind = $mainMod, P, togglespecialworkspace, passwords
      bind = $mainMod, W, togglespecialworkspace, magic
      bind = $mainMod SHIFT, W, movetoworkspace, special:magic

    #Take screenshots
      bind = , Print, exec, grim - | wl-copy && wl-paste > $(xdg-user-dir PICTURES)/$(date +'%Y-%m-%d-%H%M%S.png')

    #Move focus
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

    #Move window with mainmod + shift + arrows
      #
      #
      #
      #

    #Move/resize windows
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

    #Control audio volume
      bindel=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

    #Enter workspace mode
      bind = $mainMod, S, submap, wsmap
      submap = wsmap

    #Eat stray inputs
    #currently doesn't work?
      bind = , catchall, exec, #nothing

    #Switch workspaces
      bind = , 1, workspace, 1
      bind = , 2, workspace, 2
      bind = , 3, workspace, 3
      bind = , 4, workspace, 4
      bind = , 5, workspace, 5
      bind = , 6, workspace, 6
      bind = , 7, workspace, 7
      bind = , 8, workspace, 8
      bind = , 9, workspace, 9
      bind = , 0, workspace, 10

    #Move active window to a workspace
      bind = SHIFT, 1, movetoworkspace, 1
      bind = SHIFT, 2, movetoworkspace, 2
      bind = SHIFT, 3, movetoworkspace, 3
      bind = SHIFT, 4, movetoworkspace, 4
      bind = SHIFT, 5, movetoworkspace, 5
      bind = SHIFT, 6, movetoworkspace, 6
      bind = SHIFT, 7, movetoworkspace, 7
      bind = SHIFT, 8, movetoworkspace, 8
      bind = SHIFT, 9, movetoworkspace, 9
      bind = SHIFT, 0, movetoworkspace, 10

    #Scroll through existing workspaces
      bind = , mouse_down, workspace, e+1
      bind = , mouse_up, workspace, e-1

    #Launch program and go to normal mode
      bind = , space, exec, $menu
      bind = , space, submap, reset

    #Go back to normal mode
      bind = , Return, submap, reset

    #Why is this needed?
      submap = reset
    '';

    settings = {

      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun -show-icons";
      "$calculator" = "qalculate-qt";

      misc = {
        focus_on_activate="true";
        key_press_enables_dpms="true";
      };

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mainMod" = "SUPER";

      exec-once = [
        "bash ~/dotfiles/startup.sh"
        "[workspace special:passwords silent] keepassxc" #add a keyfile to this
        "[workspace special:term silent] $terminal" #add a keyfile to this
      ];

      #windowrule = [
      #  "opacity 0.99, obsidian" #doesn't help. obsidian transparency is just broken.
      #];

      #windowrulev2 = [ this was in the defaults but errors?
      #  "suppressevent maximize, class:.*"
      #];

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
