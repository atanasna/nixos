# Host-specific configuration for atanas-nix-1
{
  system = "aarch64-linux";
  kernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
}

