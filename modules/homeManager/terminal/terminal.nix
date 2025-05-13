{config, pkgs, lib, ...}: {
  options = {
    modules.terminal.enable = lib.mkEnableOption "Enable terminal customization";
  };

  config = lib.mkIf config.modules.terminal.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "MesloLGS Nerd Font:size=14";
        };
        colors = {
          alpha = 0.90;
          foreground = "${config.colors.common.foreground}";
          background = "${config.colors.common.background}";
          regular0 = "${config.colors.ansi.black}";
          regular1 = "${config.colors.ansi.red}";
          regular2 = "${config.colors.ansi.green}";
          regular3 = "${config.colors.ansi.yellow}";
          regular4 = "${config.colors.ansi.blue}";
          regular5 = "${config.colors.ansi.magenta}";
          regular6 = "${config.colors.ansi.cyan}";
          regular7 = "${config.colors.ansi.white}";
          bright0 = "${config.colors.ansi.black-bold}";
          bright1 = "${config.colors.ansi.red-bold}";
          bright2 = "${config.colors.ansi.green-bold}";
          bright3 = "${config.colors.ansi.yellow-bold}";
          bright4 = "${config.colors.ansi.blue-bold}";
          bright5 = "${config.colors.ansi.magenta-bold}";
          bright6 = "${config.colors.ansi.cyan-bold}";
          bright7 = "${config.colors.ansi.white-bold}";
        };
      };
    };

    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      colorSchemes.systemColor = {
        ansi = [
          "#${config.colors.ansi.black}"
          "#${config.colors.ansi.red}"
          "#${config.colors.ansi.green}"
          "#${config.colors.ansi.yellow}"
          "#${config.colors.ansi.blue}"
          "#${config.colors.ansi.magenta}"
          "#${config.colors.ansi.cyan}"
          "#${config.colors.ansi.white}"
        ];
        brights = [
          "#${config.colors.ansi.black-bold}"
          "#${config.colors.ansi.red-bold}"
          "#${config.colors.ansi.green-bold}"
          "#${config.colors.ansi.yellow-bold}"
          "#${config.colors.ansi.blue-bold}"
          "#${config.colors.ansi.magenta-bold}"
          "#${config.colors.ansi.cyan-bold}"
          "#${config.colors.ansi.white-bold}"
        ];
        background = "#${config.colors.common.background}";
        foreground = "#${config.colors.common.foreground}";
        selection_bg = "#${config.colors.common.background-selection}";
        #selection_fg = "";
        #cursor_bg = "";
        #cursor_fg = "";
        #cursor_border = "";
      };
      extraConfig = ''

      '';
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history.size=0;
      history.save=0;
      history.path="$HOME/.zsh/history";

      shellAliases = {
        grep="grep --colour=auto";
        egrep="egrep --colour=auto";
        fgrep="fgrep --colour=auto";
        mount="mount |column -t";
        top="btop";
        gs="git status";
      };

      plugins = [
        {
          name = "powerlevel10k";
          src  = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src  = ./.;
          file = "p10k.zsh";
        }
      ];

    };

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
