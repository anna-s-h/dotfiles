{config, pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    font.name = "mesloLGS NF";
    font.size = 14;
    settings = {
      #foreground = "#${config.colorScheme.palette.base05}";
      #background = "#${config.colorScheme.palette.base00}";
      background_opacity = "0.90";
      #background_blur = "0"; #handled by de
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
