{ config, pkgs, inputs, ... } : {

  sops.secrets.nas_credentials = {};
  fileSystems."/mnt/NAS/webscrape" = {
    device = "//192.168.8.183/Webscrape";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/NAS/media" = {
    device = "//192.168.8.183/Media";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/NAS/backups" = {
    device = "//192.168.8.183/Backups";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/Northport/plex" = { #excluded because it is used rarely enough that a mount seems overkill
    device = "//10.0.0.50";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  fileSystems."/mnt/Northport/backup" = { #excluded because it is used rarely enough that a mount seems overkill
    device = "//10.0.0.12/emulation - backup/roms";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail";
    in ["${automount_opts},credentials=${config.sops.secrets.nas_credentials.path},uid=1000,gid=100"];
  };

  #fileSystems."/mnt/NAS/sync" = { # excluded because hopefully synology sync works
  #  device = "//192.168.8.183/Sync";
  #  fsType = "cifs";
  #  options = let
  #    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #  in ["${automount_opts},credentials=./secrets/smb.txt,uid=1000,gid=100"];
  #};

}
