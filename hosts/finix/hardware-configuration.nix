{
 config,
 lib,
 pkgs,
 modulesPath,
 ...
}:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
       device = "/dev/disk/by-uuid/d26f06d0-d7f6-4e10-b15d-b3cf1c4227e1";
       fsType = "xfs";
     };

    "/boot" = {
      device = "/dev/disk/by-uuid/3F8E-C92C";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/hdd" = {
      device = "/dev/disk/by-label/HDD";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };
  };

  swapDevices = [ ];

  hardware.firmware = with pkgs; [ linux-firmware sof-firmware ];
  hardware.cpu.amd.updateMicrocode = true;
}
