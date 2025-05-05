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

    patchedMainLua = pkgs.substituteAll {
      src = ./init.lua;
      styleCss = builtins.readFile ./style.css;
    };
    src = pkgs.runCommand "solanoid-src" { } ''
      mkdir -p $out
      cp -r ${./.}/* $out/
      rm $out/init.lua
      cp ${patchedMainLua} $out/init.lua
    '';

  in {
    packages.${system}.default = astal.lib.mkLuaPackage {
      inherit pkgs src;
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
