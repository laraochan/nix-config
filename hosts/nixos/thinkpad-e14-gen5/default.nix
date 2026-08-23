{ ... }:
{
  imports = [
    ../../../modules
    ./hardware-configuration.nix
  ];

  networking.hostName = "thinkpad-e14-gen5";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
