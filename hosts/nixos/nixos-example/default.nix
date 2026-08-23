{ ... }:
{
  imports = [
    ../../../modules
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-example";

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
}
