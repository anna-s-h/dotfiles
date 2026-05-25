{ inputs, config, pkgs, lib, osConfig, ... } :
let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the shared Hyprland home-manager module.";
    };
    monitorRules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Host-specific monitor layout rules.";
    };
    binds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "User-specific keybinds.";
    };
  };

  config = lib.mkIf cfg.enable {

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [ ];
      systemd.variables = ["--all"];

      settings = {
        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        "$moda" = "SUPER";
        "$modb" = "SUPER_MOD5";

        "$terminal" = "foot";
        "$runner" = "rofi -show drun -show-icons";
        "$search" = "qs ipc call maenu search";
        "$calculator" = "[float] qalculate-qt || hyprctl dispatch focuswindow title:Qalculate"; #TODO doesn't work to focus window
        "$clipboard" = "qs ipc call clipboard toggle";
        "$fileManager" = "$terminal yazi";
        "$menu" = "qs ipc call menu main";
        "$tasks" = "[float] $terminal btop";
        "$notes" = "obsidian";
        "$notifications" = "qs ipc call notifications toggle";
        "$clock" = "qs ipc call clock toggle";
        "$calendar" = "[float] $terminal cal";
        "$controllerbinds" = ""; #TODO ???
 
        bind = cfg.binds;

        bindm = [
          #Move/resize windows
          "$moda, mouse:272, movewindow"
          "$moda, mouse:273, resizewindow"
        ];

        bindel = [
          #Control audio volume
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ];

        bindl = [
          #Control other media
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        misc = {
          enable_anr_dialog="false";
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

        workspace = [
          #"w[tv1], gapsout:0, gapsin:0"
          #"f[1], gapsout:0, gapsin:0"
          #"r[1-4], monitor: DP-1"
          #"r[6-9], monitor: HDMI-A-1"
          " 1, persistent:true, monitor:DP-1"
          " 2, persistent:true, monitor:DP-1"
          " 3, persistent:true, monitor:DP-1"
          " 4, persistent:true, monitor:DP-1"
          " 5, persistent:true, monitor:DP-1"
          " 6, persistent:true, monitor:HDMI-A-1"
          " 7, persistent:true, monitor:HDMI-A-1"
          " 8, persistent:true, monitor:HDMI-A-1"
          " 9, persistent:true, monitor:HDMI-A-1"
          "10, persistent:true, monitor:HDMI-A-1"
        ];

#windowrulev2 = [
#"noinitialfocus, workspace special:passwords, class:(keepass)"
#"bordersize 0, floating:0, onworkspace:w[tv1]"
#"rounding 0, floating:0, onworkspace:w[tv1]"
#"bordersize 0, floating:0, onworkspace:f[1]"
#"rounding 0, floating:0, onworkspace:f[1]"
#];

#layerrule = [
#  "blur on,rofi"
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
            "layers, 1, 7, overshot, slide"
            "layersOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            #"borderangle, 1, 8, default"
            "borderangle, 1, 100, linear, loop"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
  
        monitor = cfg.monitorRules;
        
        input = {
          follow_mouse = "2"; # 0 (do nothing) might be better than 2 (mouse focus independent, key focus on click)
          float_switch_override_focus = "0";
        } // lib.optionalAttrs osConfig.modules.keymap.enable {
          kb_file = "/home/solanum/dotfiles/modules/nixos/keymap.xkb";
        };

        env = [
          "HYPRCURSOR_THEME,rose-pine-hyprcursor"
          #"XKB_CONFIG_ROOT,/etc/xkb-custom:/usr/share/X11/xkb"
          #"XCURSOR_SIZE,24"
          #"QT_QPA_PLATFORMTHEME,qt5ct"
        ];

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
            color = "0xee001a1a";
            color_inactive = "0x00000000";
          };
        };
      };
    };
  };
}
