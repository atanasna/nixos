# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, meta, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # # ===== AWS EC2 needed
  # # Enable services needed for EC2 integration
  # services.ec2-instance-connect.enable = true; # Allows connecting via the AWS console
  # services.amazon-ssm-agent.enable = true;     # For AWS Systems Manager (SSM) & Session Manager
  #
  # # Ensure kernel modules for EC2 networking and storage are available
  # boot.initrd.availableKernelModules = [ "nvme" "ena" "xhci_pci" ];

  # ======

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = meta.hostname; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Sofia";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  # Conditionally enable microcode updates only on x86_64 systems
  hardware.cpu.intel.updateMicrocode = meta.node.system == "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = meta.node.system == "x86_64-linux";

  # Fixes for longhorn
  # systemd.tmpfiles.rules = [
  #   "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  # ];

  virtualisation.docker.logDriver = "json-file";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.k3s = {
    enable = true;
    role = "server";
    token = "alabalaKURVA";
    extraFlags = toString ([
     "--write-kubeconfig-mode \"0644\""
     "--cluster-init"
     "--disable servicelb"
     "--disable traefik"
     "--disable local-storage"
    ] ++ (if meta.hostname == "atanas-nix-1" then [] else [
       "--server https://homelab-0:6443"
    ]));
    clusterInit = (meta.hostname == "atanas-nix-1");
  };

  # services.openiscsi = {
  #   enable = true;
  #   name = "iqn.2016-04.com.open-iscsi:${meta.hostname}";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.king = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    # Created using mkpasswd
    hashedPassword = "$6$jjyuvbr1At7qgC0m$CWX/y2qr3VKi0OV28o97WCDeCc.R9DIKVOFIPFRE/VQwg89uq8vQj//59UuQJPbFHSSiCCUyRrMtOVeRWYwpu/";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlvAqiRg/PvT46K/svpK0naPBPfUyhENiIWCyrGrmD7C/2TDX/fhxc3bELxBCyNU9kKVqtPLOtmbKQonZmZGGL+fMQx2lgzTXTtbXx9dVTLrAA3J3fuMF/jeDACvvHeOgVkNwkjPx1iodlepfvGdCry7O6yD7FhxWalr5jETkLNex4R7f0ifUvMuekjHSOTnzIXBtcHu6eD5AGq4oC3eCn/IDl8BB4kLe+ONvR9Nr0fYe4ZMgGufVps0bAxh9fBa0SE2rdoKCnh9BvSwlNAT5BefPEb0xcGydOU16iEGAP3yW/GXe3loCAeM1o0t2epNp0WTz/fd5rkCOjCRuN6t/V atanasna"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim
     fastfetch
     # k3s
     # cifs-utils
     # nfs-utils
     git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
