{ pkgs, ... } : {
  imports = [
    ./plugins.nix
    ./remap.nix
    ./options.nix
  ];
  config = {
    enable = true;
    defaultEditor = true;
    colorschemes.ayu = {
      enable = true;
      #disable_background = true;
      settings = {
        mirage = true;
        #overrides = {
        #  "Normal" = { bg = "none"; };
        #  "NormalFloat" = { bg = "none"; };
        #};
      };
    };
  };
}
