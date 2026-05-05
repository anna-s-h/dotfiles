{ config, lib, pkgs, inputs, ... } : {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.jovian.nixosModules.default
    ./driver-configuration.nix
  ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  # Keep host setup minimal for now; no desktop/home-manager profile imported.
  users.users.gor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  jovian = {
    steam = {
      enable = true;
      #autoStart = true;
      #desktopSession = hyprlandmaybeidkyet;
    };
    devices.steamdeck = {
      enable = true;
      autoUpdate = false;
    };
    decky-loader.enable = true;
  };

  programs.nh = {
    enable = true;
    flake = "/home/gor/dotfiles";
  };

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/disk/by-uuid/1dd0693a-de30-4076-b425-5dc28c17afd1";
      #theme = "${pkgs.fetchFromGitHub {
      #  owner = "Coopydood";
      #  repo = "HyperFluent-GRUB-Theme";
      #  rev = "a034f285421bc612b10adcdc8b4c4b804b5f337d";
      #  hash = "sha256-BGcjH90Ucy6EIHHLKDh9AhrfIQbKOa3b2zkymT5aBB4=";
      #}}/nixos";
      #gfxmodeEfi = "1920x1080";
    };
  };

  system.stateVersion = "23.11";
}
