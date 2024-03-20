# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7cf22773-0d59-4a7f-9608-5d69e80ccd4c";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5681-6B08";
      fsType = "vfat";
    };

  fileSystems."/mnt/archlnx" =
    { device = "/dev/disk/by-uuid/b179a604-8039-49dc-abe7-7df6efee0630";
      fsType = "btrfs";
    };

  fileSystems."/mnt/R" =
    { device = "/dev/disk/by-uuid/b5b799b9-1262-4e00-9941-0347b5e7d995";
      fsType = "ext4";
    };

  fileSystems."/mnt/B" =
    { device = "/dev/disk/by-uuid/304978a7-f7a6-4fc4-b968-0856d1ee1f6b";
      fsType = "ext4";
    };

  fileSystems."/mnt/A" =
    { device = "/dev/disk/by-uuid/a6edc64d-e8c4-4a0a-9b98-c47ff32479f4";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c0b036ef-8fea-4c6b-8c84-d4a7498769c5"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.virbr0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
