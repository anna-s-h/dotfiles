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
  
  nix.extraOptions = ''
    extra-substituters = https://nixpkgs-python.cachix.org https://devenv.cachix.org;
    extra-trusted-public-keys = nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;
  '';

  users.users.solanum = {
    isNormalUser = true;
    description = "solanum";
    extraGroups = [
      "networkmanager"
      "wheel"
      config.services.kubo.group
      "input"
      "uinput"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "solanum" = import ./home.nix;
    };
    backupFileExtension = "hm-backup";
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${config.home-manager.users."solanum".home.homeDirectory}/keys/age.txt";

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

