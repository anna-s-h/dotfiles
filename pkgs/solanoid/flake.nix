{
  description = "Solanoid Astal Shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, astal }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

  in {
    packages.${system}.default = astal.lib.mkLuaPackage {
      inherit pkgs;
      src = ./src;
      name = "solanoid";
      extraPackages = [
        astal.packages.${system}.astal3
        astal.packages.${system}.io
        astal.packages.${system}.notifd
        astal.packages.${system}.hyprland
        astal.packages.${system}.mpris
        astal.packages.${system}.tray
        pkgs.dart-sass
      ];
    };
  };
}
