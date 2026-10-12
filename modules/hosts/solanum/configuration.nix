{ self, inputs, config, ... }: {

  flake.nixosConfigurations.solanumConfiguration = { pkgs, lib, ... }: {

    imports = [ self.nixosModules.solanumHardware ];

    nix.settings.experimental-features = [ "nix-command" "flakes"];
    #nixpkgs.config.allowUnfree = true;

    boot = {
      resumeDevice = "/dev/disk/by-uuid/95e4d071-afd4-4199-9cd5-e7f89ba77b80";
      kernelParams = [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia_drm.modeset=1"
        "nvidia_drm.fbdev=1" 
      ];
      kernel.sysfs = {
        kernel.mm.transparent_hugepage = {
          enabled = "madvise";
          defrag = "defer";
          shmem_enabled = "advise";
          khugepaged.defrag=1;
        };
      };

      loader.grub = {
        enable = true;
        device = "/dev/sda"; # or "nodev" for efi only
# efiSupport = true;
# efiInstallAsRemovable = true;
# efiSysMountPoint = "/boot/efi";

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
    };

    networking = {
      hostName = "solanum";
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      firewall.enable = false;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = false; #TODO why?
    };

    hardware.graphics.enable = true;
#nixos fixed it on their end but I still can't get rid of this...
    services.xserver.enable = true;
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true; # Required!
        open = false;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    hardware.bluetooth.enable = true;

    services.printing.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
#jack.enable = true;
#media-session.enable = true;
    };

    services.resolved = {
      enable = true;
#extraConfig = ''
#  DNSStubListener=yes
#  Cache=yes
#  DNSOverTLS=yes
#'';
    };
  };
}
