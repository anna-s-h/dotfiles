{ config, lib, pkgs, inputs, ... } : {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.jovian.nixosModules.default
    ./driver-configuration.nix
    ../../users/default.nix
    ../solanum/nas.nix
  ] ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  user.gor.enable = true;

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
      autoStart = true;
      desktopSession = "hyprland";
      user = "gor";
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

  home-manager.sharedModules = [
    {
      modules.hyprland.monitorRules = [
        "eDP-1, preferred, auto, 1, transform, 3"
      ];
    }
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  nix.distributedBuilds = true;

  nix.buildMachines = [{
    hostName = "192.168.1.50"; # IP or hostname of your remote builder
    system = "x86_64-linux";   # Architecture of the remote machine
    sshUser = "root";          # Or your dedicated builder user
    sshKey = "";
    maxJobs = 4;               # Max concurrent jobs to send to this builder
    speedFactor = 2;           # Higher number = faster machine
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  }];

  system.stateVersion = "23.11";
}
