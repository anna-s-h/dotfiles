{ ... } : {
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
      settings = {
        mirage = true;
      };
    };
  };
}
