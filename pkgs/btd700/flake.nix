
{
  description = "Sennheiser BTD 700 CLI control utility";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems you want this flake to support
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      
      # Helper function to generate attributes for each system
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f rec {
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Define the derivation properly inside the flake
        btd700ctl = pkgs.stdenv.mkDerivation {
          pname = "btd700ctl";
          version = "unstable-2026";

          src = pkgs.fetchFromGitHub {
            owner = "sobalap";
            repo = "btd700ctl";
            rev = "main";
            # Tip: Set a real hash or change to lib.fakeHash to get the right one
            hash = "sha256-qi/bWpGxeBbJeWLGdAnMzUFLNRvTTmUrBedSK4LkSF4="; 
          };

          nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
          buildInputs = [ pkgs.libusb1 pkgs.systemd pkgs.hidapi];
          
          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp btd700d $out/bin/
            cp btd700_example $out/bin/btd700ctl
            runHook postInstall
          '';         

        };
      });
    in
    {
      # This exposes the compilation output to 'nix build'
      packages = forAllSystems (env: {
        default = env.btd700ctl;
      });

      # This exposes the executable binary to 'nix run'
      apps = forAllSystems (env: {
        default = {
          type = "app";
          program = "${env.btd700ctl}/bin/btd700ctl";
        };
      });
    };
}
