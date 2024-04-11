{ config, lib, ... } : {
  config = {
    colors = {
      accent = config.ansi.blue; # originally, yellow
      common = {
        background = "171B24";
        background-panel = "1F2430";
        background-selectedline = "242936";
        background-selection = "33415E";
        background-gutter = "404755";
        background-gutter-active = "5F687A";
        midtone = "707A8C";
        foreground-idle = "607080";
        foreground-accent = "8A9199";
        foreground = "CCCCC6";
      };

      ansi = {
        black = config.colors.common.background;
        red = "F07178";
        green = "BBE67E";
        yellow = "FFCC66";
        blue = "5CCFE6";
        magenta = "D4BFFF";
        cyan = "95E6CB";
        white = config.colors.common.foreground;
        black-bold = config.colors.common.midtone;
        red-bold = "FF3333";
        green-bold = "A2F032"; #I made this one up
        yellow-bold = "FFA759";
        blue-bold = "80D4FF";
        magenta-bold = "BB9AFF"; #I made this one up
        cyan-bold = "78FCD0"; #I made this one up
        white-bold = "EEECE3";
      };
      syntax = {
        critical-background = "332430";
        error = config.colors.ansi.red-bold;
        number = config.colors.ansi.yellow;
        markup = "F28779";
        constant = config.colors.ansi.magenta;
        tag = config.colors.ansi.blue;
        regex = config.colors.ansi.cyan-bold;
        comment = "5C6773";
        operator  = "F29E74";
        regionmarker-background = "2A4254";
        variable = "73D0FF";
        keyword = config.colors.ansi.yellow-bold;
        string = config.colors.ansi.green;
        function  = "FFD57F";
        spellcheck = "F27983";
        character = config.colors.ansi.cyan;
        special = "FFE6B3";
      };
      other = {
        bookmark = config.colors.ansi.blue-bold;
        line-added = "A6CC70";
        line-modified = "77A8D9";
        line-removed = "F27983";
        colors.warning = config.colors.ansi.yellow-bold;
      };
    };
  };
}
