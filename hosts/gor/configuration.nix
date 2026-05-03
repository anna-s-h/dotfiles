{ config, lib, pkgs, inputs, ... } : {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.jovian.nixosModules.default
  ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  networking.hostName = "gor";

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
      autoUpdate = true;
    };
    decky-loader.enable = true;
  };

  programs.nh = {
    enable = true;
    flake = "/home/gor/dotfiles";
  };

  system.stateVersion = "23.11";
}
