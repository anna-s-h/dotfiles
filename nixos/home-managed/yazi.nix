{ config, pkgs, inputs, ... } : {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      #preview = true;
      #hidden = true;
      #drawbox = true;
      #icons = true;
      #ignorecase = true;
    };
  };
}
