{
  # Import all your configuration modules here
  imports = [
    ./plugins.nix
    ./remap.nix
    ./options.nix
  ];

  colorschemes.ayu = {
    enable = true;
    settings = {
      mirage = true;
    };
  };
}
