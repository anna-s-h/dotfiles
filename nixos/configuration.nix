{ config, pkgs, inputs, ... } : {
  imports = [
    ./hardware-configuration.nix
    ./driver-configuration.nix
    ./packages.nix
    ./nas.nix
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];


  nix.settings.experimental-features = [ "nix-command" "flakes"];

  users.users.solanum = {
    isNormalUser = true;
    description = "solanum";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "solanum" = import ./home.nix;
    };
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${config.home-manager.users."solanum".home.homeDirectory}/keys/age.txt";

  fileSystems."/mnt/big" = {
    device = "/dev/disk/by-uuid/fb1929c4-602f-4b52-83e9-e7b76fdffb4b";
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

  #needs researched
  #system.autoUpgrade = {
  #  enable = true;
  #  flake = inputs.self.outPath;
  #  flags = [
  #    "--update-input"
  #    "nixpkgs"
  #    "-L"
  #  ];
  #  dates = "9:00"
  #}

  #doesn't work
  #also should be modularized
  users.users.keepass-start = {
    home = "/var/lib/keepass-start";
    createHome = true;
    isSystemUser = true;
    group = "keepass-start";
  };
  users.groups.keepass-start = {};
  sops.secrets.keepass = {owner="keepass-start";};
  #systemd.user.services.keepass-start = {
  #  description = "unlock keepass vault on startup";
  #  serviceConfig.PassEnvironment = "DISPLAY";
  #  script = ''
  #    cat ${config.sops.secrets.keepass.path} | keepassxc --pw-stdin ~/SynologyDrive/Passwords.kdbx
  #  '';
  #  wantedBy = ["default.target"];
  #  serviceConfig = {
  #    User = "keepass-start";
  #    WorkingDirectory = "/var/lib/keepass-start";
  #  };
  #};

  # Don't touch
  system.stateVersion = "23.11";
}

