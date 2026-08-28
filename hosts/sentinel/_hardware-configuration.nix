# Generated from the same physical hardware that currently runs aegis.
# Disk/filesystem configuration lives in `default.nix`; this file only
# captures hardware-specific modules and platform settings.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "uas"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  hardware = {
    cpu = {
      intel = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
