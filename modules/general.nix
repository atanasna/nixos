{ config, lib, pkgs, ... }:
{
  options = {
    mods.general = {
      hostname = lib.mkOption {
        type = lib.types.string;
        description = "Name of the machine";
      };
      arch = lib.mkOption {
        type = lib.types.enum ["aarch64-linux" "x86_64-linux"];
        default = "aarch64-linux";
        description = "CPU architecture type";
      };
    };
  };

  config = {
    networking.hostName = config.mods.general.hostname; # Define your hostname.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    time.timeZone = "Europe/Sofia";
  };
}


