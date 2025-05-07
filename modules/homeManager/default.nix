{ inputs, ... } : {
  imports = [
    ./rofi.nix
    ./yazi.nix
    ./nixvim/nixvim.nix
    ./firefox/firefox.nix
    ./hyprland/hyprland.nix
    ./terminal/terminal.nix
    ./hypridle/hypridle.nix
    ../nixos/systemcolor/colors.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
