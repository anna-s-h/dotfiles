{config, pkgs, ...}:

{
  programs.rofi.terminal = "kitty -o confirm_os_window_close=0";
  programs.kitty = {
    enable = true;
    font.name = "mesloLGS-Nerd-Font-Mono";
    font.size = 14;
    settings = {
      foreground = "#${config.colors.common.foreground}";
      background = "#${config.colors.common.background}";
      selection_background = "#${config.colors.common.background-selection}"; 
      background_opacity = "0.90";
      color0  = "#${config.colors.ansi.black}";
      color1  = "#${config.colors.ansi.red}";
      color2  = "#${config.colors.ansi.green}";
      color3  = "#${config.colors.ansi.yellow}";
      color4  = "#${config.colors.ansi.blue}";
      color5  = "#${config.colors.ansi.magenta}";
      color6  = "#${config.colors.ansi.cyan}";
      color7  = "#${config.colors.ansi.white}";
      color8  = "#${config.colors.ansi.black-bold}";
      color9  = "#${config.colors.ansi.red-bold}";
      color10 = "#${config.colors.ansi.green-bold}";
      color11 = "#${config.colors.ansi.yellow-bold}";
      color12 = "#${config.colors.ansi.blue-bold}";
      color13 = "#${config.colors.ansi.magenta-bold}";
      color14 = "#${config.colors.ansi.cyan-bold}";
      color15 = "#${config.colors.ansi.white-bold}";
    };
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
        ls="ls --color=auto";
        ll="ls -la";
        lsd="ls -d .* --color=auto";
        grep="grep --colour=auto";
        egrep="egrep --colour=auto";
        fgrep="fgrep --colour=auto";
        mount="mount |column -t";
        top="btop";
        lf="cd \"$(command lf -print-last-dir \"$@\")\"";

        # do not delete / or prompt if deleting more than 3 files at a time #
        #alias rm="rm -I --preserve-root"

        # confirmation #
        #alias mv="mv -i"
        #alias cp="cp -i"
        #alias ln="ln -i"
    };

    plugins = [
      {
        name = "powerlevel10k";
        src  = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src  = ./p10k;
        file = "p10k.zsh";
      }
    ];

  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}
