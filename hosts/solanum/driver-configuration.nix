{ config, pkgs, inputs, ... } : {

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  hardware.graphics.enable = true;

  #nixos fixed it on their end but I still can't get rid of this...
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true; # Required!
    open = false;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1" 
  ];

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

  networking.hostName = "solanum";
  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
