{ pkgs, ... } : let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "864a021";
    hash = "sha256-m3709h7/AHJAtoJ3ebDA40c77D+5dCycpecprjVqj/k=";
  };
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "f";

    settings = {
      manager = {
        show_hidden = true;
        #ignorecase = true;
      };
    };

    plugins = {
      toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
    };

    initLua = ''
    '';

    keymap = {
      manager.prepend_keymap = [ 
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = ["c" "r"];
          run = "shell '${pkgs.ripdrag} $0'";
          desc = "Drag the hovered file";
        }
      ];
    };
  };
}

