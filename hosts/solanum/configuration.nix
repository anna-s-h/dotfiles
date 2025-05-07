{ config, pkgs, inputs, ... } : {
  imports = [
    ./hardware-configuration.nix
    ./driver-configuration.nix
    ./nas.nix
    ../../modules/nixos/default.nix
    ../../modules/nixos/systemcolor/custom-mirage.nix
    ../../users/solanum/configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    #clean.enable = true;
    #clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/solanum/dotfiles";
  };

  environment.systemPackages = with pkgs; [
    git-crypt
    sops
    grim
    vlc
    samba
    ripgrep
    wireguard-tools #TODO do I need this?
  ];

  solkeymap.enable = true;

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  fileSystems."/mnt/new_a" = {
    device = "/dev/disk/by-uuid/85cb773b-1d04-459d-b388-79cbde5b1c1e";
    fsType = "ext4";
  };
  fileSystems."/mnt/new_b" = {
    device = "/dev/disk/by-uuid/a250e1ca-d960-4237-8e67-131602645440";
    fsType = "ext4";
  };
  fileSystems."/mnt/big" = {
    device = "/dev/disk/by-uuid/fb1929c4-602f-4b52-83e9-e7b76fdffb4b";
    fsType = "ext4";
  };
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/e670de52-7c00-4a77-a76d-119685b9848c";
    fsType = "ext4";
  };

  boot = {
    #initrd.systemd.enable = true;
    resumeDevice = "/dev/disk/by-uuid/95e4d071-afd4-4199-9cd5-e7f89ba77b80";
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      #useOSProber = true;
      #this looks super crusty, probably due to bios
      #theme = "${pkgs.fetchFromGitHub {
      #  owner = "Coopydood";
      #  repo = "HyperFluent-GRUB-Theme";
      #  rev = "a034f285421bc612b10adcdc8b4c4b804b5f337d";
      #  hash = "sha256-BGcjH90Ucy6EIHHLKDh9AhrfIQbKOa3b2zkymT5aBB4=";
      #}}/nixos";
      #gfxmodeEfi = "1920x1080";
    };
    #supportedFilesystems = [ "ntfs" ];
  };

  # Don't touch
  system.stateVersion = "23.11";
}

