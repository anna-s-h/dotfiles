{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      name = "solanoid"; # how to name the executable
      src = ./src; # should contain init.lua

      # add extra glib packages or binaries
      extraPackages = [
        astal.packages.${system}.astal3
        astal.packages.${system}.io
        pkgs.dart-sass
      ];

      #shellHook = ''
      #  solanoid
      #  read -p "Press enter to exit"
      #  exit
      #'';

    };

    #this never worked
    devShell.${system} = astal.devShells.${system}.default // {
      buildInputs = [
        pkgs.lua
        pkgs.lgi
        pkgs.pkg-config 
      ];

      shellHook = ''
      '';
    };
  };
}
