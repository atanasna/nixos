{
  # Base
  hostname = "atanas-n1";

  # System
  arch = "aarch64-linux";
  kernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
}

