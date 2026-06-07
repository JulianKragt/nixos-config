# Replace with output of `nixos-generate-config --no-filesystems` from the host.
{ ... }:
{
  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "sd_mod"
    "xhci_pci"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "kvm-amd"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
