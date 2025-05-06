{ config, pkgs, inputs, ... } : let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
in{

  #TODO remember how sopsnix works and clean this up a bit
  sops.secrets.nas_credentials = {};
  fileSystems."/mnt/NAS/webscrape" = {
    device = "//192.168.8.183/Webscrape";
    fsType = "cifs";
    options = ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/NAS/media" = {
    device = "//192.168.8.183/Media";
    fsType = "cifs";
    options = ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/NAS/backups" = {
    device = "//192.168.8.183/Backups";
    fsType = "cifs";
    options = ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/NAS/sync" = { #TODO get synology sync working instead
    device = "//192.168.8.183/Sync";
    fsType = "cifs";
    options = ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

}
