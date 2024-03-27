{
  colors = {
    accent = ansi.blue; #originally, yellow
    common = {
        background = "#171B24";
        background_accent = "#1F2430";
        background_selectedline = "#242936";
        background_selection = "#33415E";
        midtone = "#707A8C";
        foreground_accent = "#8A9199";
        foreground = "#CCCAC2";
    };
    ansi = {
        black = common.background;
        red = "#F07178";
        green = "#BBE67E";
        yellow = "#FFCC66";
        blue = "#5CCFE6";
        magenta = "#D4BFFF";
        cyan = "#95E6CB";
        white = common.foreground;
        black_bold = common.midtone;
        red_bold = "#FF3333";
        green_bold = "#A2F032"; #I made this one up
        yellow_bold = "#FFAE57";
        blue_bold = "#80D4FF";
        magenta_bold = "#BB9AFF"; #I made this one up
        cyan_bold = "#78FCD0"; #I made this one up
        white_bold = "#EEECE3";
    };
    syntax = {
      critical_background = "#332430";
      error = ansi.red_bold;
      number = ansi.yellow;
      markup = ansi.red;
      constant = ansi.magenta;
      tag = ansi.blue;
      regex = ansi.cyan;
      comment = "#5C6773";
      operator  = ansi.blue_bold;
      regionmarker_background = "#2A4254";
      variable = ansi.blue;
      keyword = ansi.yellow_bold;
      string = ansi.green;
      function  = "#FFD57F";
      spellcheck = "#F27983";
      character = ansi.cyan;
    };
  };
}

ayuvim:
    let s:palette.special   = "#FFC44C"

    let s:palette.panel     = "#272D38"
    let s:palette.guide     = "#3D4751"
    let s:palette.line      = "#242B38"
    let s:palette.selection = "#343F4C"
    let s:palette.fg        = "#D9D7CE"
    let s:palette.fg_idle   = "#607080"

ayu-kate:
    "text-styles":
        "Annotation": "#FFE6B3"
        "Attribute","Extension","RegionMarker": "#73D0FF"
        "Operator": "#F29E74"
        "XMLElement Symbols": "#3D7A8B"
    "editor-colors":
        "BracketMatching": "#383E4C"
        "CodeFolding": "#252C3E"
        "CurrentLine": "#191E2A"
        "CurrentLineNumber": "#606979"
        "IconBorder": "#222733"
        "IndentationLine": "#383F4C"
        "LineNumbers": "#444B59"
        "MarkBookmark": "#73D0FF"
        "MarkBreakpointActive": "#F28779"
        "MarkBreakpointReached": "#FFE6B3"
        "MarkExecution": "#95E6CB"
        "MarkWarning": "#BAE67E"
        "ReplaceHighlight": "#7F553B"
        "ModifiedLines": "#77A8D9"
        "SavedLines": "#A6CC70"
        "SearchHighlight": "#606979"
        "Separator": "#2C313D"
        "TabMarker": "#303642"
        "TemplateBackground": "#1D222E"
        "TemplateFocusedPlaceholder": "#596171"
        "TemplatePlaceholder": "#434957"
        "TemplateReadOnlyPlaceholder": "#232834"
        "WordWrapMarker": "#303642"
