{ config, pkgs, inputs, ... } : let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=30s,nofail,uid=1000,gid=100";
  nas_credentials = "credentials=/mnt/NAS/credentials";
in{

  # TODO consider the following
  # my attempt to move all secrets management into one place
  # has made it difficult to make this work.
  # Ideally this would still put the credentials in the nix store...
  # But the file should be generated or copied from the password store.

  fileSystems."/mnt/NAS/webscrape" = {
    device = "//10.0.0.68/Webscrape";
    fsType = "cifs";
    options = ["${automount_opts},${nas_credentials}"];
  };

  fileSystems."/mnt/NAS/media" = {
    device = "//10.0.0.68/Media";
    fsType = "cifs";
    options = ["${automount_opts},${nas_credentials}"];
  };

  fileSystems."/mnt/NAS/backups" = {
    device = "//10.0.0.68/Backups";
    fsType = "cifs";
    options = ["${automount_opts},${nas_credentials}"];
  };

  #fileSystems."/mnt/NAS/sync" = { #TODO get synology sync working instead
  #  device = "//192.168.8.183/Sync";
  #  fsType = "cifs";
  #  options = ["${automount_opts},${nas_credentials}"];
  #};

}
