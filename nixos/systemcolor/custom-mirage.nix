{ config } : {
  colors = {
    accent = config.colors.ansi.blue; #originally, yellow
    common = {
      background = "#171B24";
      background_panel = "#1F2430";
      background_selectedline = "#242936";
      background_selection = "#33415E";
      background_gutter = "#404755";
      background_gutter_active = "#5F687A";
      midtone = "#707A8C";
      foreground_idle = "#607080";
      foreground_accent = "#8A9199";
      foreground = "#CCCCC6";
    };

    ansi = {
      black = config.colors.common.background;
      red = "#F07178";
      green = "#BBE67E";
      yellow = "#FFCC66";
      blue = "#5CCFE6";
      magenta = "#D4BFFF";
      cyan = "#95E6CB";
      white = config.colors.common.foreground;
      black_bold = config.colors.common.midtone;
      red_bold = "#FF3333";
      green_bold = "#A2F032"; #I made this one up
      yellow_bold = "#FFA759";
      blue_bold = "#80D4FF";
      magenta_bold = "#BB9AFF"; #I made this one up
      cyan_bold = "#78FCD0"; #I made this one up
      white_bold = "#EEECE3";
    };
    syntax = {
      critical_background = "#332430";
      error = config.colors.ansi.red_bold;
      number = config.colors.ansi.yellow;
      markup = "#F28779";
      constant = config.colors.ansi.magenta;
      tag = config.colors.ansi.blue;
      regex = config.colors.ansi.cyan_bold;
      comment = "#5C6773";
      operator  = "#F29E74";
      regionmarker_background = "#2A4254";
      variable = "#73D0FF";
      keyword = config.colors.ansi.yellow_bold;
      string = config.colors.ansi.green;
      function  = "#FFD57F";
      spellcheck = "#F27983";
      character = config.colors.ansi.cyan;
      special = "#FFE6B3";
    };
    other = {
      bookmark = config.colors.ansi.blue_bold;
      line_added = "#A6CC70";
      line_modified = "#77A8D9";
      line_removed = "#F27983";
      colors.warning = config.colors.ansi.yellow_bold;
    };
  };
             }
