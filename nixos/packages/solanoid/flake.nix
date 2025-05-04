{
  description = "Solanoid Astal Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      name = "solanoid";
      src = ./.;
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

    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.lua
        pkgs.luarocks
        pkgs.dart-sass

        # Astal runtime dependencies
        astal.packages.${system}.astal3
        astal.packages.${system}.io
        astal.packages.${system}.notifd
        astal.packages.${system}.hyprland
        astal.packages.${system}.mpris
        astal.packages.${system}.tray
      ];

      shellHook = ''
  export LUA_PATH="${astal.packages.${system}.astal3}/share/lua/5.2/?.lua;${astal.packages.${system}.astal3}/share/lua/5.2/?/init.lua;;"
  export LUA_CPATH="${astal.packages.${system}.astal3}/lib/lua/5.2/?.so;;"
        lua init.lua
      '';
    };
  };
}
