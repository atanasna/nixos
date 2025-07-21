# How to install on new system

> When you boot from nixos image you are always in a liveOS environment and thus nixos-switch will not work
> The current repo should work out of the box for aarch64 otherwise known as arm

1. Apply disko to setup the disk by running:
    - `sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko#disko -- --mode zap_create_mount /tmp/homelab/nixos/disko.nix`

2. Install nixOS from the flake in the repo by runnig:
    - `sudo nixos-install --flake /tmp/homelab/nixos#atanas-nix-1`

3. Reboot the system:
    - `sudo reboot`


# Subsecuent applies should be done with
`sudo nixos-rebuild switch --flake .#atanas-nix-1`



