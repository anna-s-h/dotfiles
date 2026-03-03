{ inputs, ... } : {
  imports = [
    ./systemcolor/colors.nix
    ./hyprland/hyprland.nix
    ./hypridle/hypridle.nix
    ./terminal/terminal.nix
    ./yazi.nix
    ./nixvim/nixvim.nix
    ./firefox/firefox.nix
    ./rofi.nix
    ./music/music.nix
  ];
}
