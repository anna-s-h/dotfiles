{ config, lib, ... } : {
  options = with lib; with types; {
    colors = {
      accent = mkOption { type = str; };
      common = {
        background = mkOption { type = str; };
        background-panel = mkOption { type = str; };
        background-selectedline = mkOption { type = str; };
        background-selection = mkOption { type = str; };
        background-gutter = mkOption { type = str; };
        background-gutter-active = mkOption { type = str; };
        midtone = mkOption { type = str; };
        foreground-idle = mkOption { type = str; };
        foreground-accent = mkOption { type = str; };
        foreground = mkOption { type = str; };
      };
      ansi = { 
        black = mkOption { type = str; };
        red = mkOption { type = str; };
        green = mkOption { type = str; };
        yellow = mkOption { type = str; };
        blue = mkOption { type = str; };
        magenta = mkOption { type = str; };
        cyan = mkOption { type = str; };
        white = mkOption { type = str; };
        black-bold = mkOption { type = str; };
        red-bold = mkOption { type = str; };
        green-bold = mkOption { type = str; };
        yellow-bold = mkOption { type = str; };
        blue-bold = mkOption { type = str; };
        magenta-bold = mkOption { type = str; };
        cyan-bold = mkOption { type = str; };
        white-bold = mkOption { type = str; };
      };
      syntax = { 
        critical-background = mkOption { type = str; };
        error = mkOption { type = str; };
        number = mkOption { type = str; };
        markup = mkOption { type = str; };
        constant = mkOption { type = str; };
        tag = mkOption { type = str; };
        regex = mkOption { type = str; };
        comment = mkOption { type = str; };
        operator  = mkOption { type = str; };
        regionmarker-background = mkOption { type = str; };
        variable = mkOption { type = str; };
        keyword = mkOption { type = str; };
        string = mkOption { type = str; };
        function  = mkOption { type = str; };
        spellcheck = mkOption { type = str; };
        character = mkOption { type = str; };
        special = mkOption { type = str; };
      };
      other = { 
        bookmark = mkOption { type = str; };
        line-added = mkOption { type = str; };
        line-modified = mkOption { type = str; };
        line-removed = mkOption { type = str; };
        colors.warning = mkOption { type = str; };
      };
    };
  };
}
