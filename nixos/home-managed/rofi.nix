{ config, pkgs, inputs, ... } : {
  config.programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "mesloLGS Nerd Font Mono 14";
    theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
      "*" = {
        background-color = mkLiteral "transparent";
        foreground-color = mkLiteral "#${config.colors.common.foreground}";
        text-color = mkLiteral "@foreground-color";
        width = 512;
        #border-color = mkLiteral "#${config.colors.ansi.red-bold}";
        #border = mkLiteral "1";
      };

      "window" = {
        padding = mkLiteral "3 0";
        background-color = mkLiteral "#${config.colors.common.background}E5";
        border-color = mkLiteral "#${config.colors.accent}";
        border = mkLiteral "2";
        border-radius = mkLiteral "4";
        width = mkLiteral "50%";
      };

      "inputbar" = {
        spacing = mkLiteral "0";
        children = map mkLiteral [ "prompt" "textbox-l" "entry" "case-indicator" "textbox-r" "num-filtered-rows" "textbox-slash" "num-rows" ];
      };

      "prompt" = {
        #spacing = mkLiteral "0";
        padding = mkLiteral "0 0 0 4";
        background-color = mkLiteral "#${config.colors.ansi.green}";
        text-color = mkLiteral "#${config.colors.ansi.black}";
      };

      "textbox-l" = {
        expand = mkLiteral "false";
        width = mkLiteral "1ch";
        str = "";
        text-color = mkLiteral "#${config.colors.ansi.green}";
      };

      "entry" = {
        padding = mkLiteral "0 2";
        text-color = mkLiteral "#${config.colors.common.foreground}";
      };
      
      "textbox-r" = {
        expand = mkLiteral "false";
        width = mkLiteral "1ch";
        str = "";
        text-color = mkLiteral "#${config.colors.ansi.magenta}";
      };

      "num-filtered-rows" = {
        background-color = mkLiteral "#${config.colors.ansi.magenta}";
        text-color = mkLiteral "#${config.colors.ansi.black}";
      };

      "textbox-slash" = {
        expand = mkLiteral "false";
        width = mkLiteral "1ch";
        str = "/";
        background-color = mkLiteral "#${config.colors.ansi.magenta}";
        text-color = mkLiteral "#${config.colors.ansi.black}";
      };

      "num-rows" = {
        background-color = mkLiteral "#${config.colors.ansi.magenta}";
        text-color = mkLiteral "#${config.colors.ansi.black}";
        padding = mkLiteral "0 4 0 0";
      };

      "listview" = {
        scrollbar = mkLiteral "true";
      };

      "scrollbar" = {
        width = mkLiteral "4";
        border = mkLiteral "0";
        background-color = mkLiteral "#${config.colors.common.background-gutter}";
        handle-color = mkLiteral "#${config.colors.common.midtone}";
        handle-width = mkLiteral "8";
        padding = mkLiteral "0";
      };

      "element.selected.normal" = {
        background-color = mkLiteral "#${config.colors.common.background-selectedline}";
      };

      "element-icon" = {
        size = mkLiteral "1em";
        padding = mkLiteral "0 4";
      };

    };
#plugins = []
  };
}
