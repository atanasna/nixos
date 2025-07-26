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
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Select internationalisation properties.
    # i18n.defaultlocale = "en_us.utf-8";
    # console = {
    #   font = "lat2-terminus16";
    #   keymap = "us";
    #   #usexkbconfig = true; # use xkb.options in tty.
    # };

    networking.hostName = config.mods.general.hostname; # Define your hostname.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    time.timeZone = "Europe/Sofia";

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ 80 ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    networking.firewall.enable = false;
  };
}


