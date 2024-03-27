{ config, pkgs, inputs, ... } : {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./home-managed/firefox.nix
    ./home-managed/hyprland.nix
    ./home-managed/terminal.nix
  ];

  home.username = "solanum";
  home.homeDirectory = "/home/solanum";

  programs.eww.configDir = ./home-managed/eww;

  colorScheme = inputs.nix-colors.colorSchemes.ayu-mirage;

  ### None of this section works, for some reason

  #qt = {
  #  enable = true;
  #  platformTheme = "kde";
  #  style.name = "breeze";
  #};

  #qt = {
  #  enable = true;
  #  platformTheme = "gnome";
  #  style = {
  #    name = "Breeze-Dark";
  #    package = pkgs.libsForQt5.breeze-qt5;
  #  };
  #};

  #home.pointerCursor = {
  #  gtk.enable = true;
  #  package = pkgs.libsForQt5.breeze-gtk;
  #  name = "Breeze-Dark";
  #  size = 16;
  #};

  #home.sessionVariables = {
  #  GTK_THEME = "Breeze";
  #};

  #gtk = {
  #  enable = true;
  #  theme = {
  #    name = "Breeze-Dark";
  #    package = pkgs.libsForQt5.breeze-gtk;
  #  };
  #};


  home.file = {
    ".config/hypr/hypridle.conf".source = ./home-managed/hypridle.conf;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at one of
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #  /etc/profiles/per-user/solanum/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Don't touch
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
