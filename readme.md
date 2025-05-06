# NixOS dotfiles

This repo should be downloaded to /home/user/dotfiles

hosts/ has a folder for every computer these dots should be compatible with. Each should contain hardware, driver, and module information.
modules/ contains custom options that the hosts can use to implement common behavior. Examples include programs with their configurations, theming utilities, and personal packages.
private/ uses gitcrypt to be plaintext once downloaded to a host. This is used mostly to avoid problems with lisencing.
secrets/ uses sops-nix to be plaintext only to a service user. This is used for actually-sensitive data.
